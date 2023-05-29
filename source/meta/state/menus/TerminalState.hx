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
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import sys.io.File;
import lime.app.Application;
import flixel.util.FlxTimer;
import meta.*;
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
import sys.io.Process;

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
	var heheheha:String = '';
	var disableThisShit:Bool = false;

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

		Main.infoCounter.visible = false;

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
			Main.infoCounter.visible = true;
		//	FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
			Main.switchState(this, new MasterEditorMenu());
		}

		// I know this is lazy but
		if (FlxG.keys.justPressed.ONE) { codeTypedIn += '1'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.TWO) { codeTypedIn += '2'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.THREE) { codeTypedIn += '3'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.FOUR) { codeTypedIn += '4'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.FIVE) { codeTypedIn += '5'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.SIX) { codeTypedIn += '6'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.SEVEN) { codeTypedIn += '7'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.EIGHT) { codeTypedIn += '8'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.NINE) { codeTypedIn += '9'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.ZERO) { codeTypedIn += '0'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }

		if (FlxG.keys.justPressed.A) { codeTypedIn += 'a'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.B) { codeTypedIn += 'b'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.C) { codeTypedIn += 'c'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.D) { codeTypedIn += 'd'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.E) { codeTypedIn += 'e'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.F) { codeTypedIn += 'f'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.G) { codeTypedIn += 'g'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.H) { codeTypedIn += 'h'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.I) { codeTypedIn += 'i'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.J) { codeTypedIn += 'j'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.K) { codeTypedIn += 'k'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.L) { codeTypedIn += 'l'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.M) { codeTypedIn += 'm'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.N) { codeTypedIn += 'n'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.O) { codeTypedIn += 'o'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.P) { codeTypedIn += 'p'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.Q) { codeTypedIn += 'q'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.R) { codeTypedIn += 'r'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.S) { codeTypedIn += 's'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.T) { codeTypedIn += 't'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.U) { codeTypedIn += 'u'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.V) { codeTypedIn += 'v'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.W) { codeTypedIn += 'w'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.X) { codeTypedIn += 'x'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.Y) { codeTypedIn += 'y'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.Z) { codeTypedIn += 'z'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }
		if (FlxG.keys.justPressed.PERIOD) { codeTypedIn += '.'; keysPressed++; FlxG.sound.play(Paths.sound('terminal/terminal_key'), 0.4); disableThisShit = false; }

		if (FlxG.keys.justPressed.BACKSPACE && keysPressed > 0) {
			FlxG.sound.play(Paths.sound('terminal/terminal_bkspc'), 0.4);
			codeTypedIn = codeTypedIn.substring(0, codeTypedIn.length - 1);
		}
		if (controls.ACCEPT)
		{
			previousLines += ('>' + codeTypedIn);
			disableThisShit = false;

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
				Main.infoCounter.visible = true;
				FlxG.sound.playMusic(Paths.music('no'), 0);
				previousLines += '\n>Accessing chart editor...';
				PlayState.SONG = Song.loadFromJson(codeTypedIn, codeTypedIn);
				Main.switchState(this, new OriginalChartingState());
				addLine++;
				}
				}
				else {
					previousLines += '\n>Error or Blank\n>Returning to main';
					addLine++;
					currentType = '';
				}
				case 'run':
					disableThisShit = true;
				if (codeTypedIn == 'anticheat.exe') {
					Main.infoCounter.visible = true;
					FlxG.sound.playMusic(Paths.music('no'), 0);
					previousLines += '\n>Running AntiCheat.exe';
				//	PlayState.SONG = Song.loadFromJson('anomaly','anomaly');
					PlayState.SONG = Song.loadFromJson('thearchy','thearchy');
					Main.switchState(this, new PlayState());
					addLine++;
				}
				if (codeTypedIn == 'ori.exe') {
					previousLines += '\n>Okay look here, That person has nothing to do with this mod';
					currentType = '';
					addLine++;
				}
				else {
					previousLines += '\n>Error or Blank\n>Returning to main';
					addLine++;
					currentType = '';
				}
				case 'open':
					disableThisShit = true;
					switch (codeTypedIn) {
						case 'ryan':
							previousLines += '\n>An Avali who doesn\'t know how to speak Portuguese or English like them.\n>He just speaks in beeps and bops\n>fucking idot';
							addLine++;
						case 'connor':
							previousLines += '\n>\"Why do humans ate avali so much?\"';
							addLine++;
						case 'carson':
							previousLines += '\n>I have no idea what Carson you\'re talking about.';
							addLine++;
						case 'ian':
							previousLines += '\n>Ian is that person who saved a school and got trama.\n>He also lost half his head and left arm incase if you didn\'t know.';
							addLine++;
						case 'emma':
							previousLines += '\n>She isn\'t real.';
							addLine++;
						case 'jake':
							previousLines += '\n>He adopted Emma because he wanted to sell her to KFC';
							addLine++;
						case 'shara':
							previousLines += '\n>She works at McDonalds';
							addLine++;
						case 'jeri','gara':
							previousLines += '\n>Are they human or robots?';
							addLine++;
						case 'monster':
							previousLines += '\n>THAT\'S NOT MY REAL NAME!';
							addLine++;
						case 'mari':
							previousLines += '\n>File deleted';
							addLine++;
						case 'ooklesnookzs':
							CoolUtil.browserLoad('https://www.youtube.com/watch?v=Y7QEVuhzY-w');
						case '87':
							CoolUtil.browserLoad('https://www.youtube.com/watch?v=S-SnfN8Gn3I');
						case 'classic1926':
							previousLines += '\n>You know what fuck you, I\'m going to make you watch my sugary spire video';
							addLine++;
							heheheha = codeTypedIn;
							new FlxTimer().start(2, dumbShit);
						case 'ds':
							previousLines += '\n>:)';
							FlxG.sound.play(Paths.sound('ds_startup'), 1);
							addLine++;
							heheheha = codeTypedIn;
							new FlxTimer().start(2, dumbShit);
						case 'minor':
							FlxG.save.data.cocoNutMall = true;
							FlxG.save.flush();
							Sys.exit(0);
						case '0pizzapasta0':

						case 'fatsnivy':
							previousLines += '\n>I fucking hate you';
							addLine++;
							heheheha = codeTypedIn;
							new FlxTimer().start(2, dumbShit);
						//	System.exit(0);
						case 'tyler':
							previousLines += '\n>Bitch ass up';
							addLine++;
							heheheha = codeTypedIn;
						default:
							previousLines += '\n>Error or Blank\n>Returning to main';
							addLine++;
							currentType = '';
					}
				case 'admin':
					switch (codeTypedIn) {
						case 'ryan','connor','carson':
							previousLines += '\n>That\'s you, you fucking idiot';
							addLine++;
						case 'ian':
							PlayState.daAdmin = 'ian'; // Shoot warnings spam
							PlayState.SONG = Song.loadFromJson('blam','blam');
							Main.switchState(this, new PlayState());
						case 'jake':
							PlayState.daAdmin = 'jake'; // Offplace notes
							PlayState.SONG = Song.loadFromJson('showdown','showdown');
							Main.switchState(this, new PlayState());
						case 'shara':
							PlayState.daAdmin = 'shara'; // scroll speed 10
							PlayState.SONG = Song.loadFromJson('crash-landing','crash-landing');
							Main.switchState(this, new PlayState());
						case 'jeri','gara':
							PlayState.daAdmin = 'jeri-gara'; // scroll speed 10
							PlayState.SONG = Song.loadFromJson('chocolate','chocolate');
							Main.switchState(this, new PlayState());
						case 'monster':
							PlayState.daAdmin = 'monster'; // instantly kill the player
							PlayState.SONG = Song.loadFromJson('awaken','awaken');
							Main.switchState(this, new PlayState());
						default:
							previousLines += '\n>Error or Blank\n>Returning to main';
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
			case 'kill','exit','quit':
			codeTypedIn = '';
			previousLines += '\n>Ok lol';
			Main.switchState(this, new MasterEditorMenu());
		//	System.exit(0);
			case 'open': // LORE??!!!!?!?!?!?!?!!??!?!?!?!?!?!??
			codeTypedIn = '';
			previousLines += '\n>Choose a file to open.\n>Leave blank to return to main';
			currentType = 'open';
			addLine++;
		/*	case 'admin','root':
			codeTypedIn = '';
			previousLines += '\n>Choose a character to give admin to.\n>WARNING: They may do harmful stuff!';
			currentType = 'admin';
			addLine++;*/
			case 'what':
			codeTypedIn = '';
			FlxG.sound.play(Paths.sound('what'));
			default:
		//	if (currentType == '')
		//	previousLines += '\n>Unknown command';
			if (!disableThisShit)
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
	function dumbShit(time:FlxTimer = null) {
		switch (heheheha) {
			case 'classic1926':
				CoolUtil.browserLoad('https://www.youtube.com/watch?v=mvz8JEHIwBQ');
				System.exit(0);
			case 'ds':
			//	CoolUtil.browserLoad('https://www.youtube.com/watch?v=mvz8JEHIwBQ');
				System.exit(0);
			case 'fatsnivy':
				forceCrash();
		}
	}
	function forceCrash():Void
		{
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();
	
			dateNow = StringTools.replace(dateNow, " ", "_");
			dateNow = StringTools.replace(dateNow, ":", "'");
	
			path = "crash/" + "FE_" + dateNow + ".txt";
	
			for (stackItem in callStack)
			{
				Sys.println(stackItem);
			}
			
	
			errMsg += "\nUncaught Error: FUCK YOU!!!!!!!" + "\nPlease report this error to the GitHub page: https://github.com/ClassicBoost/FNF-Starcatcher-Reborn";
	
			if (!FileSystem.exists("crash/"))
				FileSystem.createDirectory("crash/");
	
			File.saveContent(path, errMsg + "\n");
	
			Sys.println(errMsg);
			Sys.println("Crash dump saved in no where, because it's not an actual crash bozo");
	
			var crashDialoguePath:String = "FE-CrashDialog";
	
			#if windows
			crashDialoguePath += ".exe";
			#end
	
		/*	if (FileSystem.exists(crashDialoguePath))
			{*/
				Sys.println("Found crash dialog: " + crashDialoguePath);
				new Process(crashDialoguePath, [path]);
		/*	}
			else
			{
				Sys.println("No crash dialog found! Making a simple alert instead...");
				Application.current.window.alert(errMsg, "Error!");
			}*/
	
			Sys.exit(1);
		}
}