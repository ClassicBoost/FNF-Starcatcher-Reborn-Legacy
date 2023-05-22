package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import haxe.Timer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	public static var scoreBar:FlxText;
	var scoreLast:Float = -1;

	// fnf mods
	var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';

	var cornerMark:FlxText; // engine mark at the upper right corner
	public static var centerMark:FlxText; // song display name and difficulty at the center

	private var SONG = PlayState.SONG;

	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];

	var minecraftVer:FlxText;

	var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song);
//	var diffDisplay:String = CoolUtil.difficultyFromNumber(PlayState.storyDifficulty);
	var engineDisplay:String = "AXOLOTL ENGINE v1.1.0 (FE v" + Main.gameVersion + ")";

	var textcolor:FlxColor;

	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		textcolor = 0xFFFFFFFF;

		// le healthbar setup
		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;

		scoreBar = new FlxText(FlxG.width / 2, Math.floor(barY + 40), 0, scoreDisplay);
		scoreBar.setFormat(Paths.font(PlayState.choosenfont), (PlayState.choosenfont == 'vcr.ttf' ? 18 : PlayState.choosenfont == 'Vividly-Regular.ttf' ? 24 : 20), FlxColor.WHITE);
	//	if (PlayState.choosenfont == 'pixel.otf') scoreBar.setFormat(Paths.font('pixel.otf'), 12, FlxColor.WHITE);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		updateScoreText();
		// scoreBar.scrollFactor.set();
		scoreBar.antialiasing = !PlayState.curStage.startsWith("school");
		scoreBar.color = textcolor;
		add(scoreBar);

		if (PlayState.choosenfont == 'pixel.otf') engineDisplay = '${Main.gameVersion}';

		cornerMark = new FlxText(0, 0, 0, engineDisplay);
		cornerMark.setFormat(Paths.font(PlayState.choosenfont), 18, FlxColor.WHITE);
		cornerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(cornerMark);
		cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
		cornerMark.color = textcolor;
		cornerMark.antialiasing = !PlayState.curStage.startsWith("school");

		centerMark = new FlxText(0, 0, 0, '• ${infoDisplay + ' - ' + PlayState.composerStuff} •');
		centerMark.setFormat(Paths.font(PlayState.choosenfont), 24, FlxColor.WHITE);
		centerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		centerMark.alpha = 0;
		add(centerMark);
		if (Init.trueSettings.get('Downscroll'))
			centerMark.y = (FlxG.height - centerMark.height / 2) - 30;
		else
			centerMark.y = (FlxG.height / 24) - 10;
		centerMark.screenCenter(X);
		centerMark.color = textcolor;
		centerMark.antialiasing = !PlayState.curStage.startsWith("school");

		if (PlayState.choosenfont == 'minecraft.otf') {
		minecraftVer = new FlxText(0, 0, 0, '');
		minecraftVer.setFormat(Paths.font(PlayState.choosenfont), 20, FlxColor.WHITE);
		minecraftVer.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(minecraftVer);
		minecraftVer.antialiasing = false;
		Main.infoCounter.visible = false;
		}

		// counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys())
				judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);
			for (i in 0...judgementNameArray.length)
			{
				var textAsset:FlxText = new FlxText(5
					+ (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0, '', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font(PlayState.choosenfont), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				textAsset.color = textcolor;
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();
	}

	var counterTextSize:Int = 18;

	function sortByShit(Obj1:String, Obj2:String):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');

	var times:Array<Float> = [];
	override public function update(elapsed:Float)
	{
		if (PlayState.cpuControlled) 
			scoreBar.text = '[BOTPLAY]';

		if (PlayState.choosenfont == 'minecraft.otf') {
			var now:Float = Timer.stamp();
			times.push(now);
			while (times[0] < now - 1)
				times.shift();
		}

		if (PlayState.choosenfont == 'minecraft.otf') minecraftVer.text = '0.0.23a_01\n${times.length} FPS\n';

		updateScoreText();
	}

	public function updateScoreText()
	{
		var importSongScore = PlayState.lerpScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;
		var scoretext:String = 'Score: ';
		var accuracytext:String = 'Accuracy: ';
		var missestext:String = 'Combo Breaks: ';
		var ranktext:String = 'Rank: ';
		var divider:String = " - "; // apparently the centered bold dot isn't on the starbound font

		if (PlayState.choosenfont == 'pixel.otf') {
			divider = ' • ';
			scoretext = 'SCR: '; accuracytext = ''; missestext = 'MISS: '; ranktext = '';
		}
		else if (PlayState.choosenfont == 'vcr.ttf' || PlayState.choosenfont == 'Vividly-Regular.ttf' || PlayState.choosenfont == 'minecraft.otf')
			divider = ' • ';

		if (!PlayState.cpuControlled) {
		scoreBar.text = '$scoretext$importSongScore';
		// testing purposes
		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
			if (PlayState.choosenfont != 'vcr.ttf' && PlayState.choosenfont != 'Vividly-Regular.ttf') {
		//	scoreBar.text += divider + 'HP: ${PlayState.healthBar.percent}%';
		//	scoreBar.text += divider + accuracytext + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%';
			scoreBar.text += divider + missestext + Std.string(PlayState.misses);
			scoreBar.text += divider + accuracytext + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%${Timings.comboDisplay}';
			} else { // base forever engine
			scoreBar.text += divider + accuracytext + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%${Timings.comboDisplay}';
			scoreBar.text += divider + missestext + Std.string(PlayState.misses);
			scoreBar.text += divider + ranktext + Std.string(Timings.returnScoreRating());
			}
			if (PlayState.practiceMode) scoreBar.text += divider + 'Practice Mode';
		}
		}
		scoreBar.text += '\n';
		scoreBar.x = Math.floor((FlxG.width / 2) - (scoreBar.width / 2));

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys())
			{
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${Timings.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public static function fadeOutSongText()
	{
		FlxTween.tween(centerMark, {alpha: 0}, 2, {ease: FlxEase.linear});
	}

	public static function fadeInSongText() {
		FlxTween.tween(centerMark, {alpha: 1}, 1, {ease: FlxEase.linear});
	}

	public static function bopScore() {
		if (!PlayState.cpuControlled) {
		FlxTween.cancelTweensOf(scoreBar);
		scoreBar.scale.set(1.075, 1.075);
		FlxTween.tween(scoreBar, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
		}
	}
}
