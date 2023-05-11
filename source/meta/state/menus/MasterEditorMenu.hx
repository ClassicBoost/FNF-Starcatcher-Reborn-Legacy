package meta.state.menus;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import gameObjects.userInterface.HealthIcon;
import lime.utils.Assets;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import openfl.media.Sound;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MasterEditorMenu extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control

	var options:Array<String> = ['characters','codes','terminal'];
	var canSnap:Array<Float> = [];
	private var grpTexts:FlxTypedGroup<Alphabet>;

	// CODES SHIT
	var codeOverlay:FlxSprite;
	var codeText:FlxText;
	var codeTypedIn:String = '';
	var disableMainControls:Bool = false;
	var changeMainText:String = 'Type in numbers to enter codes\nAll codes are 5 digits long\n\nENTER to access\nR to reset\nESC to exit';
	var keysPressed:Int = 0;

	var scoreTextThing:FlxText;

	public static var inTerminal:Bool = false;

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if DISCORD_RPC
		Discord.changePresence('EXTRAS MENU', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		if (!inTerminal)
		FlxG.sound.playMusic(Paths.music('terminal'), 0.7);

		inTerminal = true;

		// add the menu items
		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(90, 320, options[i], true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 42).makeGraphic(FlxG.width, 42, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var directoryTxt:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'EXTRAS MENU', 32);
		directoryTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		directoryTxt.scrollFactor.set();
		add(directoryTxt);

		codeOverlay = new FlxSprite(0, 0).makeGraphic(3000, 3000, 0xFF000000);
		codeOverlay.alpha = 0;
		add(codeOverlay);

		codeText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, '', 32);
		codeText.setFormat(32, FlxColor.WHITE, CENTER);
		codeText.screenCenter();
		codeText.alpha = 0;
		codeText.scrollFactor.set();
		add(codeText);

		scoreTextThing = new FlxText(textBG.x, textBG.y + 200, FlxG.width, '', 32);
		scoreTextThing.setFormat(Paths.font("hobo.ttf"), 32, FlxColor.WHITE, CENTER);
		scoreTextThing.screenCenter();
		scoreTextThing.y += 200;
		scoreTextThing.alpha = 0;
		scoreTextThing.scrollFactor.set();
		add(scoreTextThing);

		scoreTextThing.text = '';

		changeSelection();

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;
	var ratingTxt:String = '?';
	var whatSelected:String = '';

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if (!disableMainControls) {
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
			inTerminal = false;
			Main.switchState(this, new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch (curSelected) {
				case 0:
					
				case 1:
					disableMainControls = true;
					openUpCodes();
				case 2:
					Main.switchState(this, new TerminalState());
			}
		}
		} else {
			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
				disableMainControls = false;
				closeCodes();
			}
			if (FlxG.keys.justPressed.R) {
				codeTypedIn = '';
				keysPressed = 0;
				FlxG.sound.play(Paths.sound('terminal_bkspc'), 0.4);
			}

			// I know this is lazy but
			if (keysPressed < 5) {
			if (FlxG.keys.justPressed.ONE) { codeTypedIn += '1'; keysPressed++; }
			if (FlxG.keys.justPressed.TWO) { codeTypedIn += '2'; keysPressed++; }
			if (FlxG.keys.justPressed.THREE) { codeTypedIn += '3'; keysPressed++; }
			if (FlxG.keys.justPressed.FOUR) { codeTypedIn += '4'; keysPressed++; }
			if (FlxG.keys.justPressed.FIVE) { codeTypedIn += '5'; keysPressed++; }
			if (FlxG.keys.justPressed.SIX) { codeTypedIn += '6'; keysPressed++; }
			if (FlxG.keys.justPressed.SEVEN) { codeTypedIn += '7'; keysPressed++; }
			if (FlxG.keys.justPressed.EIGHT) { codeTypedIn += '8'; keysPressed++; }
			if (FlxG.keys.justPressed.NINE) { codeTypedIn += '9'; keysPressed++; }
			if (FlxG.keys.justPressed.ZERO) { codeTypedIn += '0'; keysPressed++; }

			if (FlxG.keys.justPressed.ONE || FlxG.keys.justPressed.TWO || FlxG.keys.justPressed.THREE || FlxG.keys.justPressed.FOUR || FlxG.keys.justPressed.FIVE
				|| FlxG.keys.justPressed.SIX || FlxG.keys.justPressed.SEVEN || FlxG.keys.justPressed.EIGHT || FlxG.keys.justPressed.NINE || FlxG.keys.justPressed.ZERO) {
				FlxG.sound.play(Paths.sound('terminal_key'), 0.4);
				changeMainText = 'Type in numbers to enter codes\nAll codes are 5 digits long\n\nENTER to access\nR to reset\nESC to exit';
				whatSelected = '';
				updateScore();
				}
			}
			if (FlxG.keys.justPressed.BACKSPACE && keysPressed > 0) {
			//	codeTypedIn--;
				FlxG.sound.play(Paths.sound('terminal_bkspc'), 0.4);
				codeTypedIn = codeTypedIn.substring(0, codeTypedIn.length - 1);
				keysPressed--;
				whatSelected = '';
				updateScore();
			}
			if (controls.ACCEPT)
			{
				changeMainText = 'Type in numbers to enter codes\nAll codes are 5 digits long\n\nENTER to access\nR to reset\nESC to exit';
				switch (codeTypedIn) {
				case '69420','42069','318008','69696':
					changeMainText = 'Haha, very funny';
				case '99999':
					changeMainText = 'Football';
					CoolUtil.browserLoad('https://www.youtube.com/watch?v=Hv6RbEOlqRo');
				case '52022':
					FlxG.sound.play(Paths.sound('psych'), 0.6);
				case '12018':
					PlayState.SONG = Song.loadFromJson('wtf', 'wtf');
					Main.switchState(this, new PlayState());
				case '':
					changeMainText = 'Put something down!';
				case '123456789': // it's impossible to insert more than 5 digits
					changeMainText = 'Okay like, even though you aren\'t suppose to insert more than 5 digits, but still fuck you.';
				case '92020':
					PlayState.SONG = Song.loadFromJson('thearchy', 'thearchy');
					Main.switchState(this, new PlayState());
				default:
					FlxG.sound.play(Paths.sound('error'), 0.6);
				}
				keysPressed = 0;
				codeTypedIn = '';
			}
		}
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		codeText.text = '$changeMainText\n\n>$codeTypedIn';
		codeText.screenCenter();

		super.update(elapsed);
	}

	var lastCurSelected:Int = 0;

	function changeSelection(change:Int = 0)
	{
	//	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}
	function openUpCodes() {
		changeMainText = 'Type in numbers to enter codes\nAll codes are 5 digits long\n\nENTER to access\nR to reset\nESC to exit';
		FlxTween.tween(codeOverlay, {alpha: 0.75}, 0.25, {ease: FlxEase.linear});
		FlxTween.tween(codeText, {alpha: 1}, 0.25, {ease: FlxEase.linear});
	}
	function closeCodes() {
		codeOverlay.alpha = 0;
		codeText.alpha = 0;
		codeTypedIn = '';
	}

	function updateScore() {
	switch (codeTypedIn) {
		case '92020':
			whatSelected = 'thearchy';
		case '12018':
			whatSelected = 'wtf';
	}
	switch (Highscore.getRating(whatSelected)) {
		case 1:
			ratingTxt = 'D';
		case 2:
			ratingTxt = 'C';
		case 3:
			ratingTxt = 'B';
		case 4:
			ratingTxt = 'A';
		case 5:
			ratingTxt = 'S';
		default:
			ratingTxt = '?';
	}
	if (whatSelected != '') {
		if (Highscore.getScore(whatSelected, 0) != 0 || Highscore.getRating(whatSelected) != 0) {
		scoreTextThing.text = 'Score: ' + Highscore.getScore(whatSelected, 0) + ' | ' + ratingTxt;
		if (scoreTextThing.alpha == 0) {
			FlxTween.cancelTweensOf(scoreTextThing);
			FlxTween.tween(scoreTextThing, {alpha: 1}, 1, {ease: FlxEase.linear});
		}
		}
	} else scoreTextThing.alpha = 0;
	}
}