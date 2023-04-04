package freeplay;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class FreeplayClassicState extends MusicBeatState
{
	var options:Array<String> = ['tutorial',
	'bopeebo',
	'fresh',
	'dadbattle',
	'spookeez',
	'south',
	'sugar rush',
	'pico',
	'philly nice',
	'blammed',
	'satin',
	'high',
	'mil'];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	private var musicPlaying:Bool = false;

	var menuText:FlxText;

	private var disablebop = false;
	private var disablethisthingy:Bool = false;
	private var disablescreenbop:Bool = false;
	private var lengthshit:Float = 0.6;
	private var songBeat:Float = 0.6;

	// icons
	var locationThing:String = 'menus/freeplay/icons/';
	var lockedAss:FlxSprite;

	var ctrl = FlxG.keys.justPressed.CONTROL;
	var space = FlxG.keys.justPressed.SPACE;
	var accepted = FlxG.keys.justPressed.ENTER;

	var num:Int = 0;

	override function create() {

		persistentUpdate = true;
		PlayState.isStoryMode = false;

		#if desktop
		DiscordClient.changePresence("Freeplay State", null);
		#end

		curSelected = 0;

		accepted = false;

		disablebop = false;
		lengthshit = 0.6;
		disablescreenbop = false;
		disablethisthingy = false;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/starcatcher'));
	//	bg.color = 0xFFB428FF;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "WIP", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(500, 44, 0xFF000000);
		scoreBG.alpha = 0.6;
	//	add(scoreBG);

	//	add(scoreText);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(20, 320, options[i], true);
			optionText.isMenuItem2 = true;
			optionText.targetY = i - curSelected;
		//	optionText.screenCenter();
		//	optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);

			var maxWidth = 980;
			if (optionText.width > maxWidth)
			{
				optionText.scaleX = maxWidth / optionText.width;
			}
			optionText.snapToPosition();
		}

		FlxG.sound.playMusic(Paths.music('starcatcher'), 0.7);	

		selectorLeft = new Alphabet(0, 0, '', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '', true);
		add(selectorRight);

		menuText = new FlxText(12, FlxG.height - 200, 0, "", 12);
		menuText.scrollFactor.set();
		menuText.borderSize = 1.5;
		menuText.screenCenter(X);
		menuText.x += 50;
		menuText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(menuText);

		changeSelection();

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var leText:String = "Press CTRL to open the Gameplay Changers Menu";
		var size:Int = 18;
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		super.create();
	}

	override function closeSubState() {
		changeSelection(0);
		persistentUpdate = true;
		super.closeSubState();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			if(zoomTween != null) zoomTween.cancel();
			persistentUpdate = false;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);	
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new FreeplayPREState());
		}

		var daSelected:String = options[curSelected];
		if(FlxG.keys.justPressed.CONTROL)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if (FlxG.keys.justPressed.SPACE) {

		}
		else if (FlxG.keys.justPressed.ENTER) {
			if(zoomTween != null) zoomTween.cancel();
			musicPlaying = false;

			PlayState.classicMode = true;
			switch (daSelected) {
				case 'sugar rush':
					PlayState.SONG = Song.loadFromJson('classic-sugar-rush', 'classic-sugar-rush', false);
					LoadingState.loadAndSwitchState(new PlayState());
				case 'philly nice':
					PlayState.SONG = Song.loadFromJson('classic-philly-nice', 'classic-philly-nice', false);
					LoadingState.loadAndSwitchState(new PlayState());
				default:
					PlayState.SONG = Song.loadFromJson('classic-' + options[curSelected], 'classic-' + options[curSelected], false);
					LoadingState.loadAndSwitchState(new PlayState());
			}
		}

		if (!disablebop && !disablethisthingy && musicPlaying) {
			disablethisthingy = true;
			new FlxTimer().start((lengthshit * 2), zoomCam);
		}
	}
	var zoomTween:FlxTween;
	public function zoomCam(time:FlxTimer = null) {
		if (!disablebop) {
		disablebop = true;
		if (disablethisthingy) {
		FlxG.camera.zoom = 1.05;
		zoomoutthing();
		}
		disablebop = false;
		disablethisthingy = false;
	}
	}

	function zoomoutthing() {
		if(zoomTween != null) zoomTween.cancel();
		zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
			{
				zoomTween = null;
			}
		});
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.9;
			item.color = 0xFFFFFFFF;
			if (item.targetY == 0) {
				item.alpha = 1;
				item.color = 0xFFFFEF68;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}