package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import meta.*;
import meta.data.PlayerSettings;
import meta.data.dependency.Discord;
import meta.data.dependency.FNFTransition;
import meta.data.dependency.FNFUIState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

// Here we actually import the states and metadata, and just the metadata.
// It's nice to have modularity so that we don't have ALL elements loaded at the same time.
// at least that's how I think it works. I could be stupid!
class Main extends Sprite
{
	// class action variables
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: Init, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 120, // default framerate
		skipSplash: false, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};
	public static var mainClassState:Class<FlxState> = Init;
	public static var gameVersion:String = '0.3.1';
	public static var starcatcherVER:String = 'DEMO 2';
	public static var infoCounter:Overlay;

	public static var useNewMenu:Bool = true;

	// heres gameweeks set up!

	/**
		Small bit of documentation here, gameweeks are what control everything in my engine
		this system will eventually be overhauled in favor of using actual week folders within the 
		assets.
		Enough of that, here's how it works
		[ [songs to use], [characters in songs], [color of week], name of week ]
	**/
	public static var gameWeeks:Array<Dynamic> = [
	//	[['Tutorial'], ['gf'], [FlxColor.fromRGB(129, 100, 223)], 'Funky Beginnings'],
		[
			['Interruption', 'Raptor-Love', 'Showdown', 'Retired'],
			['jake', 'gf', 'jake', 'jake'],
			[FlxColor.fromRGB(129, 100, 223)],
			'vs. DADDY DEAREST'
		],
		[
			['Haunted', 'Mirage', 'Chocolate', 'Monster'],
			['jeri-gara', 'jeri-gara', 'jeri-gara', 'monster'],
			[FlxColor.fromRGB(30, 45, 60)],
			'Spooky Month'
		],
		[
			['Ian', 'Supplies', 'Laser'],
			['ian'],
			[FlxColor.fromRGB(111, 19, 60)],
			'vs. Pico'
		],
		[
			['Startup', 'Flying-High', 'Meteorites', 'Crash-Landing'],
			['shara'],
			[FlxColor.fromRGB(203, 113, 170)],
			'MOMMY MUST MURDER'
		],
		[
			['Cocoa', 'Eggnog', 'Winter-Horrorland'],
			['parents-christmas', 'parents-christmas', 'monster-christmas'],
			[FlxColor.fromRGB(141, 165, 206)],
			'RED SNOW'
		],
		[
			['Senpai', 'Roses', 'Thorns'],
			['mari', 'mari', 'spirit'],
			[FlxColor.fromRGB(206, 106, 169)],
			"hating simulator ft. moawling"
		],
	];

	public static var bonusSongs:Array<Dynamic> = [
		[
			['Overdrive'],
			['whitty'],
			[FlxColor.fromRGB(129, 100, 223)],
			''
		],
		[
			['Target-Practice'],
			['matt'],
			[FlxColor.fromRGB(129, 100, 223)],
			''
		],
		[
			['Massacre'],
			['tabi'],
			[FlxColor.fromRGB(129, 100, 223)],
			''
		],
	];

	public static var creditsStuff:Array<Dynamic> = [
		[
			['Classic1926','Spades','The-Spooky-Austroraptor','Downfrown','Everton123'],
			['classic','spades','austro','down','everton'],
			[FlxColor.fromRGB(255,255,255)],
			''
		],
	];

	// most of these variables are just from the base game!
	// be sure to mess around with these if you'd like.

	public static function main():Void
		{
			Lib.current.addChild(new Main());
		}
	
		// calls a function to set the game up
		public function new()
		{
			super();
	
			/**
				ok so, haxe html5 CANNOT do 120 fps. it just cannot.
				so here i just set the framerate to 60 if its complied in html5.
				reason why we dont just keep it because the game will act as if its 120 fps, and cause
				note studders and shit its weird.
			**/
	
			Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	
			#if (html5 || neko)
			framerate = 60;
			#end
	
			// simply said, a state is like the 'surface' area of the window where everything is drawn.
			// if you've used gamemaker you'll probably understand the term surface better
			// this defines the surface bounds
	
			var stageWidth:Int = Lib.current.stage.stageWidth;
			var stageHeight:Int = Lib.current.stage.stageHeight;
	
			if (game.zoom == -1.0)
				{
					var ratioX:Float = stageWidth / game.width;
					var ratioY:Float = stageHeight / game.height;
					game.zoom = Math.min(ratioX, ratioY);
					game.width = Math.ceil(stageWidth / game.zoom);
					game.height = Math.ceil(stageHeight / game.zoom);
				}
	
			FlxTransitionableState.skipNextTransIn = true;
	
			// here we set up the base game
			var gameCreate:FlxGame;
		//	gameCreate = new FlxGame(gameWidth, gameHeight, mainClassState, zoom, framerate, framerate, skipSplash);
			gameCreate = new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen);
			addChild(gameCreate); // and create it afterwards
	
			// default game FPS settings, I'll probably comment over them later.
			// addChild(new FPS(10, 3, 0xFFFFFF));
	
			// begin the discord rich presence
			#if DISCORD_RPC
			Discord.initializeRPC();
			Discord.changePresence('');
			#end
	
			// test initialising the player settings
			PlayerSettings.init();
	
			infoCounter = new Overlay(0, 0);
			infoCounter.visible = true;
			addChild(infoCounter);
		}
	
		public static function framerateAdjust(input:Float)
		{
			return input * (60 / FlxG.drawFramerate);
		}
	
		/*  This is used to switch "rooms," to put it basically. Imagine you are in the main menu, and press the freeplay button.
			That would change the game's main class to freeplay, as it is the active class at the moment.
		 */
		public static var lastState:FlxState;
	
		public static function switchState(curState:FlxState, target:FlxState)
		{
			// Custom made Trans in
			mainClassState = Type.getClass(target);
			if (!FlxTransitionableState.skipNextTransIn)
			{
				curState.openSubState(new FNFTransition(0.35, false));
				FNFTransition.finishCallback = function()
				{
					FlxG.switchState(target);
				};
				return trace('changed state');
			}
			FlxTransitionableState.skipNextTransIn = false;
			// load the state
			FlxG.switchState(target);
		}
	
		public static function updateFramerate(newFramerate:Int)
		{
			// flixel will literally throw errors at me if I dont separate the orders
			if (newFramerate > FlxG.updateFramerate)
			{
				FlxG.updateFramerate = newFramerate;
				FlxG.drawFramerate = newFramerate;
			}
			else
			{
				FlxG.drawFramerate = newFramerate;
				FlxG.updateFramerate = newFramerate;
			}
		}
	
		function onCrash(e:UncaughtErrorEvent):Void
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
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}
	
			errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/ClassicBoost/FNF-Starcatcher-Reborn";
	
			if (!FileSystem.exists("crash/"))
				FileSystem.createDirectory("crash/");
	
			File.saveContent(path, errMsg + "\n");
	
			Sys.println(errMsg);
			Sys.println("Crash dump saved in " + Path.normalize(path));
	
			var crashDialoguePath:String = "FE-CrashDialog";
	
			#if windows
			crashDialoguePath += ".exe";
			#end
	
			if (FileSystem.exists(crashDialoguePath))
			{
				Sys.println("Found crash dialog: " + crashDialoguePath);
				new Process(crashDialoguePath, [path]);
			}
			else
			{
				Sys.println("No crash dialog found! Making a simple alert instead...");
				Application.current.window.alert(errMsg, "Error!");
			}
	
			Sys.exit(1);
		}
	}