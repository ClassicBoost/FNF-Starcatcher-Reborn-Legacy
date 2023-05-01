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
import flash.system.System;
import sys.thread.Mutex;
import sys.thread.Thread;
import meta.state.charting.*;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class TerminalState extends MusicBeatState
{

	var bg:FlxSprite; // the background has been separated for more control

	// CODES SHIT
	var codeOverlay:FlxSprite;
	var codeText:FlxText;
	var codeTypedIn:String = '';
	var disableMainControls:Bool = false;
	var changeMainText:String = 'Starcatcher Reborn Terminal[v1.2] - Forever Engine 0.3.1';
	var keysPressed:Int = 0;
	var currentType:String = '';
	var previousLines:String = '';
	var addLine:Int = 0;

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
		bg = new FlxSprite().loadGraphic(Paths.image('menus/base/terminal'));
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		codeText = new FlxText('');
		codeText.setFormat(20, FlxColor.WHITE, LEFT);
		codeText.x = 10;
		codeText.y = 10;
		codeText.alpha = 1;
		codeText.scrollFactor.set();
		add(codeText);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];



		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
			Main.switchState(this, new MasterEditorMenu());
		}

		// I know this is lazy but
		if (FlxG.keys.justPressed.ONE) { codeTypedIn += '1'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.TWO) { codeTypedIn += '2'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.THREE) { codeTypedIn += '3'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.FOUR) { codeTypedIn += '4'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.FIVE) { codeTypedIn += '5'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.SIX) { codeTypedIn += '6'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.SEVEN) { codeTypedIn += '7'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.EIGHT) { codeTypedIn += '8'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.NINE) { codeTypedIn += '9'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.ZERO) { codeTypedIn += '0'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }

		if (FlxG.keys.justPressed.A) { codeTypedIn += 'a'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.B) { codeTypedIn += 'b'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.C) { codeTypedIn += 'c'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.D) { codeTypedIn += 'd'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.E) { codeTypedIn += 'e'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.F) { codeTypedIn += 'f'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.G) { codeTypedIn += 'g'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.H) { codeTypedIn += 'h'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.I) { codeTypedIn += 'i'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.J) { codeTypedIn += 'j'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.K) { codeTypedIn += 'k'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.L) { codeTypedIn += 'l'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.M) { codeTypedIn += 'm'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.N) { codeTypedIn += 'n'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.O) { codeTypedIn += 'o'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.P) { codeTypedIn += 'p'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.Q) { codeTypedIn += 'q'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.R) { codeTypedIn += 'r'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.S) { codeTypedIn += 's'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.T) { codeTypedIn += 't'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.U) { codeTypedIn += 'u'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.V) { codeTypedIn += 'v'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.W) { codeTypedIn += 'w'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.X) { codeTypedIn += 'x'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.Y) { codeTypedIn += 'y'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.Z) { codeTypedIn += 'z'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }
		if (FlxG.keys.justPressed.PERIOD) { codeTypedIn += '.'; keysPressed++; FlxG.sound.play(Paths.sound('terminal_key'), 0.4); }

		if (FlxG.keys.justPressed.BACKSPACE && keysPressed > 0) {
			FlxG.sound.play(Paths.sound('terminal_bkspc'), 0.4);
			codeTypedIn = codeTypedIn.substring(0, codeTypedIn.length - 1);
		}
		if (controls.ACCEPT)
		{
			previousLines += ('>' + codeTypedIn);

			addLine++;

			if (addLine >= 20) {
				previousLines = '';
				addLine = 0;
			}

			switch (currentType) {
				case 'chart':
				if (codeTypedIn != '' && currentType == 'chart') {
				if (codeTypedIn == 'anomaly' || codeTypedIn == 'cheating') {
				previousLines += '\n>Cannot access chart editor for $codeTypedIn\n>Reason: FUCK YOU HAHAHAHAHA';
				currentType = '';
				addLine++;
				}
				else {
				FlxG.sound.playMusic(Paths.music('no'), 0);
				previousLines += '\n>Accessing chart editor...';
				PlayState.SONG = Song.loadFromJson(codeTypedIn, codeTypedIn);
				Main.switchState(this, new OriginalChartingState());
				addLine++;
				}
				}
				else {
					previousLines += '\n>Returning to main';
					addLine++;
					currentType = '';
				}
				case 'run':
				if (codeTypedIn == 'anticheat.exe') {
					FlxG.sound.playMusic(Paths.music('no'), 0);
					previousLines += '\n>Running AntiCheat.exe';
					PlayState.SONG = Song.loadFromJson('anomaly','anomaly');
					Main.switchState(this, new PlayState());
					addLine++;
				}
				if (codeTypedIn == 'ori.exe') {
					previousLines += '\n>Okay look here, That person has nothing to do with this mod';
					currentType = '';
					addLine++;
				}
				else {
					previousLines += '\n>Returning to main';
					addLine++;
					currentType = '';
				}
			}
			switch (codeTypedIn) {
			case 'chart':
			codeTypedIn = '';
			previousLines += '\n>Please choose a song to chart!\n>Be warned that choosing a non existing song will crash!\n>Chart editor is also not upated.';
			currentType = 'chart';
			addLine++;
			case 'run':
			codeTypedIn = '';
			previousLines += '\n>What do you want to run?\n>Be warned that some executables may be unstable.';
			currentType = 'run';
			addLine++;
			case 'kill','exit':
			codeTypedIn = '';
			previousLines += '\n>Ok lol';
			System.exit(0);
			case '':
			previousLines += '\n>But like, actually put something here';
			addLine++;
			default:
		//	if (currentType == '')
		//	previousLines += '\n>Unknown command';
			currentType = '';
			addLine++;
			}
	
			keysPressed = 0;
			previousLines += '\n';
			codeTypedIn = '';
		}

		codeText.text = '$changeMainText\n\n$previousLines>$codeTypedIn';

		super.update(elapsed);
	}
}