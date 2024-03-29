package meta.state;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import gameObjects.*;
import gameObjects.userInterface.*;
import gameObjects.userInterface.notes.*;
import gameObjects.userInterface.notes.Strumline.UIStaticArrow;
import meta.*;
import meta.state.ranking.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.state.charting.*;
import meta.state.menus.*;
import meta.subState.*;
import openfl.display.GraphicsShader;
import openfl.events.KeyboardEvent;
import openfl.filters.ShaderFilter;
import openfl.media.Sound;
import openfl.utils.Assets;
import sys.io.File;

using StringTools;

#if desktop
import meta.data.dependency.Discord;
#end

class PlayState extends MusicBeatState
{
	public static var startTimer:FlxTimer;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 2;

	public static var songMusic:FlxSound;
	public static var vocals:FlxSound;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;
	private var songPositionBar:Float = 0;

	public static var cpuControlled:Bool = false;
	public static var practiceMode:Bool = false;

	public static var choosenfont:String = 'pixel-berry.ttf';

	public static var campaignScore:Int = 0;

	public static var dadOpponent:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	private var canDie:Bool = true;

	public static var assetModifier:String = 'base';
	public static var changeableSkin:String = 'default';

	private var healthToLower:Float = 0;

	private var unspawnNotes:Array<Note> = [];
	private var ratingArray:Array<String> = [];
	private var allSicks:Bool = true;

	// if you ever wanna add more keys
	private var numberOfKeys:Int = 4;

	public static var composerStuff:String = 'null';

	public static var inChart:Bool = false;

	// get it cus release
	// I'm funny just trust me
	private var curSection:Int = 0;
	private var camFollow:FlxObject;
	private var camFollowPos:FlxObject;

	var forceLose:Bool = false;

	// Discord RPC variables
	public static var songDetails:String = "";
	public static var detailsSub:String = "";
	public static var detailsPausedText:String = "";

	private static var prevCamFollow:FlxObject;

	private var blackBG:FlxSprite;

	private var curSong:String = "";
	private var gfSpeed:Int = 1;

	public static var health:Float = 1; // mario
	public static var combo:Int = 0;
	public static var highestCombo:Int = 0;
	public static var totalCombo:Int = 0;

	public static var misses:Int = 0;
	public static var totalMisses:Int = 0;

	public var songhasmechanics:Bool = false;
	public static var displayRank:String = 'F';

	public static var deaths:Int = 0;

	public static var lerpScore:Float = 0.0;
	public var lerpHealth:Float = 1;

	private var updateTime:Bool = true;

	public var generatedMusic:Bool = false;

	private var startingSong:Bool = false;
	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var inCutscene:Bool = false;

	public var energySine:Float = 0;
	public var energyEffect:FlxSprite;

	var forceCenter:Bool = false;

	var canPause:Bool = true;

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;
	public static var dialogueHUD:FlxCamera;

	private var round2Text:FlxText;
	public static var roundTwoCompleted:Bool = false;

	public var camDisplaceX:Float = 0;
	public var camDisplaceY:Float = 0; // might not use depending on result

	public static var currentColor:FlxColor;

	public static var cameraSpeed:Float = 1;

	public static var defaultCamZoom:Float = 1.05;

	public static var forceZoom:Array<Float>;

	public static var songScore:Int = 0;

	var latedamage:Int = 3;

	public static var useDefaultForever:Bool = false;

	private var theSongStuff:FlxText;

	var storyDifficultyText:String = "";

	public static var iconRPC:String = "";

	public static var songLength:Float = 0;

	public static var isPixelStage:Bool = false;

	public static var campaignAccuracy:Float = 0.0;
	public static var actualAccuracy:Float = 0.0;
	public static var totalSongs:Int = 0;

	public static var forceRank:Int = 0;
	private var forceRankText:FlxText;

	private var antimashshit:Bool = false;

	public var judgementText:FlxText;

	public var useNewRanking:Bool = false;

	private var idotChanged:Bool = false;

	// character icons
	public static var bfIcon:String = 'bf';
	public static var dadIcon:String = 'dad';

	public static var daAdmin:String = 'ryan'; // also as no one

	private var stageBuild:Stage;

	public static var uiHUD:ClassHUD;

	private var showStats:Bool = false;

	var noLap2:Bool = true;

	public static var daPixelZoom:Float = 6;
	public static var determinedChartType:String = "";

	public var bopType:String = 'both';

	// Pizza Tower Shit
	public var fuckingRank:FlxSprite;
	var hurtText:FlxText;
	public static var messups:Int = 0; // now this would seem like combo breaks but failing mechanics will also remove your P rank
	public var failedPrank:Bool = false;
	public static var fuckingRankText:String = 'd';
	public static var fuckingPlayer:String = 'ryan';
	public static var scoreRequired:Int = 1500; // basically how much notes there is in that song.

	public static var actualMisses:Int = 0;

	// strumlines
	private var dadStrums:Strumline;
	private var boyfriendStrums:Strumline;

	public static var strumLines:FlxTypedGroup<Strumline>;
	public static var strumHUD:Array<FlxCamera> = [];

	private var allUIs:Array<FlxCamera> = [];

	public static var forceDeath = false;



	private var fuckYouNoHit:Bool = false;

	// different players
	var bftwobutfake:Character;
	var bfbutfake:Character;
	private var hasTWOplayers:Bool = false;

	// ENERGY
	private var energyBar:FlxBar;
	private var energyBarBG:FlxSprite;
	public var energyig:Float = 0;
	public var doubleTime:Bool = false;

	var goodNotePressed:Bool = true; // not to be confised with goodNoteHit

	// stores the last judgement object
	public static var lastRating:FlxSprite;
	// stores the last combo objects in an array
	public static var lastCombo:Array<FlxSprite>;

	// at the beginning of the playstate
	override public function create()
	{
		super.create();

		// reset any values and variables that are static
		if (totalSongs == 0)
		songScore = 0;
		combo = 0;
		health = 1;
		misses = 0;
		actualMisses = 0;
		messups = 0;
		forceDeath = false;
		canDie = true;
		roundTwoCompleted = false;
		forceRank = 0;
		useDefaultForever = false;
		idotChanged = false;
		noLap2 = true;
		healthToLower = 0;
		energyig = 0;
		doubleTime = false;
		currentColor = 0xFFFFFFFF;
		// sets up the combo object array
		lastCombo = [];

		defaultCamZoom = 1.05;
		cameraSpeed = 1;
		forceZoom = [0, 0, 0, 0];

		Timings.callAccuracy();

		assetModifier = 'base';
		changeableSkin = 'default';

		// stop any existing music tracks playing
		resetMusic();
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// create the game camera
		camGame = new FlxCamera();

		// create the hud camera (separate so the hud stays on screen)
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		if (Init.trueSettings.get("Late Damage"))
			latedamage = 3;
		else
			latedamage = 1;

		bopType = 'both';

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		allUIs.push(camHUD);
		FlxCamera.defaultCameras = [camGame];

		// default song
		if (SONG == null)
			SONG = Song.loadFromJson('test', 'test');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		/// here we determine the chart type!
		// determine the chart type here
		determinedChartType = "FNF";

		// set up a class for the stage type in here afterwards
		curStage = "";
		// call the song's stage if it exists
		if (SONG.stage != null)
			curStage = SONG.stage;

		// cache shit
		displayRating('sick', 'early', true);
		popUpCombo(true);
		//

		stageBuild = new Stage(curStage);
		add(stageBuild);

		if (curStage.startsWith("school")) {
			isPixelStage = true;
		} else {
			isPixelStage = false;
		}

		// set up characters here too
		gf = new Character();
		gf.adjustPos = false;
		gf.setCharacter(300, 100, stageBuild.returnGFtype(curStage));
		gf.scrollFactor.set(0.95, 0.95);

		dadOpponent = new Character().setCharacter(50, 850, SONG.player2);
		boyfriend = new Boyfriend();
		boyfriend.setCharacter(750, 850, SONG.player1);
		if (FreeplayState.characterOverrides != 'none' && (SONG.player1 == 'ryan' || SONG.player1 == 'ryan-car' || SONG.player1 == 'ryan-christmas' || SONG.player1 == 'ryan-pixel')) boyfriend.setCharacter(750, 850, FreeplayState.characterOverrides);
		// if you want to change characters later use setCharacter() instead of new or it will break
		// this took me so long to notice, wtf.

		bftwobutfake = new Character();
		bftwobutfake.setCharacter(1050,850,'connor');
	//	bftwobutfake.flipX = true;
		add(bftwobutfake);
		bfbutfake = new Character();
		bfbutfake.setCharacter(750,850,SONG.player1);
		add(bfbutfake);
		remove(bfbutfake);

		var camPos:FlxPoint = new FlxPoint(gf.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

		stageBuild.repositionPlayers(curStage, boyfriend, dadOpponent, gf);
		stageBuild.dadPosition(curStage, boyfriend, dadOpponent, gf, camPos);

		fuckingPlayer = boyfriend.curCharacter;

		if (SONG.assetModifier != null && SONG.assetModifier.length > 1)
			assetModifier = SONG.assetModifier;

		changeableSkin = Init.trueSettings.get("UI Skin");
		if (isPixelStage) {
			if ((determinedChartType == "FNF"))
			assetModifier = 'pixel';

			choosenfont = 'pixel.otf';
		} else choosenfont = Init.trueSettings.get("Font Style") + '.ttf';

		gf.color = 0xFFFFFFFF;
		dadOpponent.color = 0xFFFFFFFF;
		boyfriend.color = 0xFFFFFFFF;

		// add characters
		add(gf);

		// add limo cus dumb layering
		if (curStage == 'highway')
			add(stageBuild.limo);

		add(dadOpponent);
		add(boyfriend);

		add(stageBuild.foreground);

		// force them to dance
		dadOpponent.dance();
		gf.dance();
		boyfriend.dance();

		// set song position before beginning
		Conductor.songPosition = -(Conductor.crochet * 4);

		// EVERYTHING SHOULD GO UNDER THIS, IF YOU PLAN ON SPAWNING SOMETHING LATER ADD IT TO STAGEBUILD OR FOREGROUND
		// darken everything but the arrows and ui via a flxsprite
		var darknessBG:FlxSprite = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		darknessBG.alpha = (100 - Init.trueSettings.get('Stage Opacity')) / 100;
		darknessBG.scrollFactor.set(0, 0);
		add(darknessBG);

		blackBG = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackBG.alpha = 0;
		blackBG.scrollFactor.set(0, 0);
		add(blackBG);

		if (stageBuild.mood == 'dark')
			blackBG.alpha = 0.5;

		// strum setup
		strumLines = new FlxTypedGroup<Strumline>();

		// generate the song
		generateSong(SONG.song);

		// set the camera position to the center of the stage
		camPos.set(gf.x + (gf.frameWidth / 2), gf.y + (gf.frameHeight / 2));

		// create the game camera
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(camPos.x, camPos.y);
		// check if the camera was following someone previously
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		add(camFollowPos);

		// actually set the camera up
		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		// initialize ui elements
		startingSong = true;
		startedCountdown = true;
		forceCenter = false;

		//
		var placement = (FlxG.width / 2);
		dadStrums = new Strumline(placement - (FlxG.width / 4), this, dadOpponent, false, true, false, 4, Init.trueSettings.get('Downscroll'));
		dadStrums.visible = (!Init.trueSettings.get('Centered Notefield') && !forceCenter);
		boyfriendStrums = new Strumline(placement + ((!Init.trueSettings.get('Centered Notefield') && !forceCenter) ? (FlxG.width / 4) : 0), this, boyfriend, true, false, true,
			4, Init.trueSettings.get('Downscroll'));

		strumLines.add(dadStrums);
		strumLines.add(boyfriendStrums);

		// strumline camera setup
		strumHUD = [];
		for (i in 0...strumLines.length)
		{
			// generate a new strum camera
			strumHUD[i] = new FlxCamera();
			strumHUD[i].bgColor.alpha = 0;

			strumHUD[i].cameras = [camHUD];
			allUIs.push(strumHUD[i]);
			FlxG.cameras.add(strumHUD[i]);
			// set this strumline's camera to the designated camera
			strumLines.members[i].cameras = [camHUD];
		}

		bfIcon = boyfriend.curCharacter;
		dadIcon = dadOpponent.curCharacter;

		fuckingRank = new FlxSprite();
		fuckingRank.frames = Paths.getSparrowAtlas('UI/ranks/${Init.trueSettings.get('Ranks Skin')}');

		composerStuff = 'null';

		if (Init.trueSettings.get("Back to the Basics")) {
			useDefaultForever = true;
			fuckingRank.visible = false;
		}

		switch (curSong.toLowerCase()) {
			case 'mirage':
			composerStuff = 'Spades';
			scoreRequired = 500; //142,450
			case 'wtf':
			composerStuff = 'I can\'t find the original source who made this';
			scoreRequired = 850;
			forceCenter = true;
			gf.visible = false;
			useDefaultForever = true;
			fuckingRank.visible = false;
			case 'thearchy':
			composerStuff = 'Original by Maevings | Cover by Classic1926';
			fuckingRank.visible = false;
			gf.visible = false;
			useDefaultForever = true;
			healthToLower = 0.005;
			scoreRequired = 601;
		//	boyfriend.visible = false;
			case 'blam':
			composerStuff = 'Spades';
			scoreRequired = 525; // 165,200
			case 'anomaly','cheating':
			choosenfont = 'vcr.ttf';
			fuckingRank.visible = false;
			gf.visible = false;
			boyfriend.visible = false;
			useDefaultForever = true;
			healthToLower = 0.005;
			case 'error':
			choosenfont = 'vcr.ttf';
			fuckingRank.visible = false;
			case 'ataefull':
			choosenfont = 'minecraft.otf';
			fuckingRank.frames = Paths.getSparrowAtlas('UI/ranks/pixel');
			noLap2 = false;
			scoreRequired = 1050;
			gf.visible = false;
			hasTWOplayers = true;
			healthToLower = 0.01;
			case 'awaken':
				healthToLower = 0.007;
			case 'vac':
			choosenfont = 'comic.ttf';
			gf.visible = false;
			canPause = false;
			case 'dancebound':
			scoreRequired = 265;
			gf.visible = false;
		}

		fuckingRank.animation.addByPrefix('p', 'P', 24, true);
		fuckingRank.animation.addByPrefix('s+', 'S+', 24, true);
		fuckingRank.animation.addByPrefix('s', 'S0', 24, true);
		fuckingRank.animation.addByPrefix('a', 'A', 24, true);
		fuckingRank.animation.addByPrefix('b', 'B', 24, true);
		fuckingRank.animation.addByPrefix('c', 'C', 24, true);
		fuckingRank.animation.addByPrefix('d', 'D', 24, true);
		fuckingRank.antialiasing = true;
		fuckingRank.animation.play('d', true);
		fuckingRank.setGraphicSize(Std.int(fuckingRank.width * 0.35));
		fuckingRank.updateHitbox();
		fuckingRank.cameras = [camHUD];
		fuckingRank.x += 1000;
		add(fuckingRank);

		if (!hasTWOplayers)
			remove(bftwobutfake);

		scoreRequired = (scoreRequired * 350);

		uiHUD = new ClassHUD();

		energyEffect = new FlxSprite(1200,70).loadGraphic(Paths.image('UI/default/base/energyUse'));
		energyEffect.scrollFactor.set();
		energyEffect.cameras = [camHUD];
		energyEffect.visible = false;
		energyEffect.screenCenter();
		add(energyEffect);

		songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		if (!Init.trueSettings.get('Downscroll'))
		songPosBG.y = 10;
		else
		songPosBG.y = FlxG.height * 0.875;
		songPosBG.screenCenter(X);
		songPosBG.scrollFactor.set();
		songPosBG.alpha = 0;
		songPosBG.cameras = [camHUD];
		if (Init.trueSettings.get("Show Song Progression"))
		add(songPosBG);
		
		songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
			'songPositionBar', 0, 1);
		songPosBar.scrollFactor.set();
		songPosBar.numDivisions = 400;
		songPosBar.createFilledBar(FlxColor.BLACK, 0xFF447FFF);
		songPosBar.alpha = 0;
		songPosBar.cameras = [camHUD];
		if (Init.trueSettings.get("Show Song Progression"))
		add(songPosBar);

		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;
		healthBarBG = new FlxSprite(0,
			barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		energyBarBG = new FlxSprite(1200,70).loadGraphic(Paths.image('UI/default/base/energyBar'));
		energyBarBG.scrollFactor.set();
		energyBarBG.cameras = [camHUD];

		energyBar = new FlxBar(energyBarBG.x, energyBarBG.y, RIGHT_TO_LEFT, 275, 19, this, 'energyig', 0, 100);
		energyBar.scrollFactor.set();
		energyBar.screenCenter();
		energyBar.x = 1115;
		energyBar.y = 205;
		energyBar.createFilledBar(0xFF3F3F3F, 0xFF3FFF3F);
		energyBar.numDivisions = 1000; // how much lag does this cause?
		energyBar.cameras = [camHUD];
		energyBar.angle = 90;

		if (!useDefaultForever) {
		add(energyBar);
		add(energyBarBG);
		}

		if (Init.trueSettings.get("Debug Info"))
			useNewRanking = true;

		fuckingRank.y = healthBarBG.y - 30;

		reloadCharacterIcons();
		healthBarBG.cameras = [camHUD];
		uiHUD.cameras = [camHUD];
		//

		add(uiHUD);
		add(strumLines);

		theSongStuff = new FlxText(200, 300, 0, 'hi there');
		theSongStuff.setFormat(25, FlxColor.WHITE);
		theSongStuff.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		theSongStuff.visible = showStats;
		theSongStuff.cameras = [camHUD];
		add(theSongStuff);

		judgementText = new FlxText(0, 200, 0, 'hi there');
		judgementText.setFormat(Paths.font(choosenfont), 40, FlxColor.WHITE, CENTER);
		judgementText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		judgementText.visible = true;
		judgementText.screenCenter(X);
		judgementText.cameras = [camHUD];
		judgementText.alpha = 0;
		add(judgementText);

		forceRankText = new FlxText(200, 500, 0, '>D\nC\nB\nA\nS');
		forceRankText.setFormat(24, FlxColor.WHITE, RIGHT);
		forceRankText.screenCenter();
		forceRankText.x = 200;
		forceRankText.y = 500;
		forceRankText.text = '';
		forceRankText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		forceRankText.cameras = [camHUD];
		add(forceRankText);

		hurtText = new FlxText(0, 500, 0, 'YOU\'VE HURT RYAN 20 TIMES');
		hurtText.setFormat(Paths.font(choosenfont), 40, FlxColor.WHITE);
		hurtText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		hurtText.screenCenter(X);
		hurtText.cameras = [camHUD];
		hurtText.alpha = 0;
		add(hurtText);

		round2Text = new FlxText(0, 0, 0, 'ROUND 2');
		round2Text.setFormat(Paths.font(choosenfont), 40, FlxColor.WHITE);
		round2Text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		round2Text.screenCenter(X);
		round2Text.cameras = [camHUD];
		round2Text.y = -200;
		add(round2Text);

		// create a hud over the hud camera for dialogue
		dialogueHUD = new FlxCamera();
		dialogueHUD.bgColor.alpha = 0;
		FlxG.cameras.add(dialogueHUD);

		//
		keysArray = [
			copyKey(Init.gameControls.get('LEFT')[0]),
			copyKey(Init.gameControls.get('DOWN')[0]),
			copyKey(Init.gameControls.get('UP')[0]),
			copyKey(Init.gameControls.get('RIGHT')[0])
		];

		if (!Init.trueSettings.get('Controller Mode'))
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		if (SONG.player1 == 'ryan' || SONG.player1 == 'ryan-car' || SONG.player1 == 'ryan-christmas' || SONG.player1 == 'ryan-pixel') {
		switch (FreeplayState.characterOverrides) {
			case 'connor':
				GameOverSubstate.deathSound = 'connorFRICK';
			case 'ian','ian-player':
				GameOverSubstate.deathSound = 'hylotlKO';
			default:
				GameOverSubstate.deathSound = 'avaliKO';
		}} else {
			GameOverSubstate.deathSound = 'default';
		}

		Paths.clearUnusedMemory();

		// call the funny intro cutscene depending on the song
		if (!skipCutscenes())
			songIntroCutscene();
		else
			startCountdown();

		/**
		 * SHADERS
		 *
		 * This is a highly experimental code by gedehari to support runtime shader parsing.
		 * Usually, to add a shader, you would make it a class, but now, I modified it so
		 * you can parse it from a file.
		 *
		 * This feature is planned to be used for modcharts
		 * (at this time of writing, it's not available yet).
		 *
		 * This example below shows that you can apply shaders as a FlxCamera filter.
		 * the GraphicsShader class accepts two arguments, one is for vertex shader, and
		 * the second is for fragment shader.
		 * Pass in an empty string to use the default vertex/fragment shader.
		 *
		 * Next, the Shader is passed to a new instance of ShaderFilter, neccesary to make
		 * the filter work. And that's it!
		 *
		 * To access shader uniforms, just reference the `data` property of the GraphicsShader
		 * instance.
		 *
		 * Thank you for reading! -gedehari
		 */

		// Uncomment the code below to apply the effect

		/*
			var shader:GraphicsShader = new GraphicsShader("", File.getContent("./assets/shaders/vhs.frag"));
			FlxG.camera.setFilters([new ShaderFilter(shader)]);
		 */
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey>
	{
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len)
		{
			if (copiedArray[i] == NONE)
			{
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}

	var keysArray:Array<Dynamic>;

	public function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);

		if ((key >= 0)
			&& !boyfriendStrums.autoplay
			&& (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || Init.trueSettings.get('Controller Mode'))
			&& (FlxG.keys.enabled && !paused && (FlxG.state.active || FlxG.state.persistentUpdate)))
		{
			if (generatedMusic)
			{
				var previousTime:Float = Conductor.songPosition;
				Conductor.songPosition = songMusic.time;
				// improved this a little bit, maybe its a lil
				var possibleNoteList:Array<Note> = [];
				var pressedNotes:Array<Note> = [];

				boyfriendStrums.allNotes.forEachAlive(function(daNote:Note)
				{
					if ((daNote.noteData == key) && daNote.canBeHit && !daNote.isSustainNote && !daNote.tooLate && !daNote.wasGoodHit)
						possibleNoteList.push(daNote);
				});
				possibleNoteList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				// if there is a list of notes that exists for that control
				if (possibleNoteList.length > 0)
				{
					var eligable = true;
					var firstNote = true;
					// loop through the possible notes
					for (coolNote in possibleNoteList)
					{
						for (noteDouble in pressedNotes)
						{
							if (Math.abs(noteDouble.strumTime - coolNote.strumTime) < 10)
								firstNote = false;
							else
								eligable = false;
						}

						if (eligable && !fuckYouNoHit)
						{
							goodNoteHit(coolNote, boyfriend, boyfriendStrums, firstNote); // then hit the note
							pressedNotes.push(coolNote);
						}
						// end of this little check
					}
					//
				}
				else // else just call bad notes
					if (!Init.trueSettings.get('Ghost Tapping') || antimashshit)
						missNoteCheck(true, key, boyfriend, true, true);
				Conductor.songPosition = previousTime;
			}

			if (boyfriendStrums.receptors.members[key] != null
				&& boyfriendStrums.receptors.members[key].animation.curAnim.name != 'confirm')
				boyfriendStrums.receptors.members[key].playAnim('pressed');
		}
	}

	public function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);

		if (FlxG.keys.enabled && !paused && (FlxG.state.active || FlxG.state.persistentUpdate))
		{
			// receptor reset
			if (key >= 0 && boyfriendStrums.receptors.members[key] != null)
				boyfriendStrums.receptors.members[key].playAnim('static');
		}
	}

	public function reloadCharacterIcons() {
		remove(healthBar);
		remove(iconP1);
		remove(iconP2);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'lerpHealth', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dadOpponent.barColor, boyfriend.barColor);
		healthBar.numDivisions = 1000; // how much lag does this cause?
		// healthBar
		add(healthBar);

		iconP1 = new HealthIcon(boyfriend.curCharacter, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.antialiasing = !isPixelStage;
		add(iconP1);

		iconP2 = new HealthIcon(dadOpponent.curCharacter, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.antialiasing = !isPixelStage;
		add(iconP2);

		healthBar.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];

		healthBar.alpha = (Init.trueSettings.get("Health Bar Opacity") / 100);
		healthBarBG.alpha = (Init.trueSettings.get("Health Bar Opacity") / 100);
		iconP1.alpha = (Init.trueSettings.get("Health Bar Opacity") / 100);
		iconP2.alpha = (Init.trueSettings.get("Health Bar Opacity") / 100);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if (key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if (key == keysArray[i][j])
						return i;
				}
			}
		}
		return -1;
	}

	override public function destroy()
	{
		if (!Init.trueSettings.get('Controller Mode'))
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		super.destroy();
	}

	var staticDisplace:Int = 0;

	var lastSection:Int = 0;
	var shitfart:String = 'd';

	override public function update(elapsed:Float)
	{
		stageBuild.stageUpdateConstant(elapsed, boyfriend, gf, dadOpponent);

		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, songScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpHealth = FlxMath.lerp(lerpHealth, health, CoolUtil.boundTo(elapsed * 9, 0, 1));

		if (Math.abs(lerpScore - songScore) <= 10)
			lerpScore = songScore;
		if (Math.abs(lerpHealth - health) <= 0.01)
			lerpHealth = health;

		healthBar.percent = (lerpHealth * 50);

		theSongStuff.visible = showStats;

		bfbutfake.flipX = false;
		bftwobutfake.flipX = false;

		if (daAdmin == 'monster')
			forceDeath = true;

		if (FlxG.keys.justPressed.T && hasTWOplayers && Init.trueSettings.get('Debug Info')) {
			idotChanged = !idotChanged;
			changePlayer();
			FlxG.sound.play(Paths.sound('hitsound'), 1);
		}

		energySine += 180 * elapsed;
		energyEffect.alpha = 1 - Math.sin((Math.PI * energySine) / 180);

		if (choosenfont == 'minecraft.otf' || useDefaultForever) {
		var iconLerp = 0.5;
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.initialWidth, iconP1.width, iconLerp)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.initialWidth, iconP2.width, iconLerp)));
		} else {
		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 20), 0, 1));
		iconP1.scale.set(mult, mult);
		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 20), 0, 1));
		iconP2.scale.set(mult, mult);
		}

		// messups are just mechanic fails, nothing else, as well with note misses, and you only get a P rank if you also have a MFC
		if (misses == 0 && messups == 0 && songScore != 0 && !cpuControlled && !practiceMode && !failedPrank) displayRank = 'P';

		if (cpuControlled && (curSong.toLowerCase() == 'vac') && !Init.trueSettings.get('Debug Info')) forceDeath = true;

		if (energyig > 100) {
			energyig = 100;
			FlxG.sound.play(Paths.sound('energy_full'));

			hurtText.text = 'BOOST READY TO USE';
			displayMidText();
		}

		if (energyig < 0) {
			energyig = 0;
			if (doubleTime) FlxG.sound.play(Paths.sound('energy_out'));
			doubleTime = false;
		}

		if (health < 0)
			health = 0;

		if (doubleTime) {
			energyig -= 0.04;
			energyEffect.visible = true;
		} else energyEffect.visible = false;

		if (FlxG.keys.justPressed.SPACE && !doubleTime) {
			if (energyig >= 100)
			doubleTime = true;
			else {
			FlxG.sound.play(Paths.sound('nav_insufficient_fuel'));
			hurtText.text = 'NOT ENOUGH ENERGY';
			displayMidText();
			}
		}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (healthBar.percent < 35 || forceLose) {
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (healthBar.percent > 85) {
			iconP1.animation.curAnim.curFrame = 2;
			iconP2.animation.curAnim.curFrame = 1;
		}
		else {
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}

		if (forceRank == 0) {
		if (!useDefaultForever) {
		if (songScore >= (scoreRequired * 0.25) && songScore < (scoreRequired * 0.45)) {
			fuckingRankText = 'c';
		} else if (songScore >= (scoreRequired * 0.45) && songScore < (scoreRequired * 0.65)) {
			fuckingRankText = 'b';
		} else if (songScore >= (scoreRequired * 0.65) && songScore < (scoreRequired * 0.95)) {
			fuckingRankText = 'a';
		} else if (songScore >= (scoreRequired * 0.95)) {
			if (((roundTwoCompleted && (Math.floor(Timings.getAccuracy() * 100) / 100) >= 98) || noLap2) && (misses == 0 || Init.trueSettings.get("Avali Accurate"))) fuckingRankText = 'p';
			else fuckingRankText = 's';
		} else if (songScore >= (scoreRequired * 2)) {
			if (misses == 0)
			fuckingRankText = 'p'; // fuck it
		} else if (songScore < (scoreRequired * 0.25)) {
			fuckingRankText = 'd';
		}} else {
			if (Std.string(Timings.returnScoreRating().toLowerCase()) != 'e' && Std.string(Timings.returnScoreRating().toLowerCase()) != 'f')
			fuckingRankText = Std.string(Timings.returnScoreRating().toLowerCase());
			else
			fuckingRankText = 'd';
		}
		}
		fuckingRank.animation.play('$fuckingRankText');

		if (shitfart != fuckingRankText) {
			FlxTween.cancelTweensOf(fuckingRank);
			fuckingRank.scale.set(0.45, 0.45);
			FlxTween.tween(fuckingRank, {"scale.x": 0.35, "scale.y": 0.35}, 0.5, {ease: FlxEase.cubeOut});
			shitfart = fuckingRankText;
		}
		totalCombo = combo;

		if (Init.trueSettings.get('Debug Info'))
		songDetails = 'NO LEAKS! - Rank: ' + fuckingRankText.toUpperCase();
		else
		songDetails = CoolUtil.dashToSpace(SONG.song) + ' - Rank: ' + fuckingRankText.toUpperCase();

		if (totalCombo > highestCombo)
		highestCombo = totalCombo;

		if (songScore < 0)
			songScore = 0;

		if (health > 2)
			health = 2;

		// dialogue checks
		if (dialogueBox != null && dialogueBox.alive)
		{
			// wheee the shift closes the dialogue
			if (FlxG.keys.justPressed.SHIFT)
				dialogueBox.closeDialog();

			// the change I made was just so that it would only take accept inputs
			if (controls.ACCEPT && dialogueBox.textStarted)
			{
				FlxG.sound.play(Paths.sound('dialogueClose'));
				dialogueBox.curPage += 1;

				if (dialogueBox.curPage == dialogueBox.dialogueData.dialogue.length)
					dialogueBox.closeDialog()
				else
					dialogueBox.updateDialog();
			}
		}

		if (cpuControlled) boyfriendStrums.autoplay = true
		else boyfriendStrums.autoplay = false;

		if (!inCutscene)
		{
			// pause the game if the game is allowed to pause and enter is pressed
			if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
			{
				pauseGame();
			}

			// make sure you're not cheating lol
			if (!isStoryMode)
			{
				// charting state (more on that later)
			/*	if ((FlxG.keys.justPressed.SEVEN) && (!startingSong))
				{
					resetMusic();
					if (FlxG.keys.pressed.SHIFT)
						Main.switchState(this, new ChartingState());
					else
						Main.switchState(this, new OriginalChartingState());
				}*/
				if (FlxG.keys.justPressed.SEVEN && Init.trueSettings.get('Debug Info')) {
					if (inChart)
					Main.switchState(this, new OriginalChartingState());
					else
					showStats = !showStats;
				}

				if (FlxG.keys.justPressed.EIGHT) {
					forceRank++;
					forceRankText.visible = true;
					if (forceRank > 6)
						forceRank = 1;
					songScore = 0;
				}
				switch (forceRank) {
					case 1:
						forceRankText.text = '>D\nC\nB\nA\nS\nP\n';
						fuckingRankText = 'd';
					case 2:
						forceRankText.text = 'D\n>C\nB\nA\nS\nP\n';
						fuckingRankText = 'c';
					case 3:
						forceRankText.text = 'D\nC\n>B\nA\nS\nP\n';
						fuckingRankText = 'b';
					case 4:
						forceRankText.text = 'D\nC\nB\n>A\nS\nP\n';
						fuckingRankText = 'a';
					case 5:
						forceRankText.text = 'D\nC\nB\nA\n>S\nP\n';
						fuckingRankText = 's';
					case 6:
						forceRankText.text = 'D\nC\nB\nA\nS\n>P\n';
						fuckingRankText = 'p';
						roundTwoCompleted = true;
				}

				if (FlxG.keys.justPressed.ONE && Init.trueSettings.get('Debug Info')) {
					songScore = 0;
					endSong();
				}

				if (FlxG.keys.justPressed.L && Init.trueSettings.get('Debug Info')) {
					defaultCamZoom -= 0.01;
				}

				if (FlxG.keys.justPressed.SIX && Init.trueSettings.get('Debug Info'))
					cpuControlled = !cpuControlled;

				if (FlxG.keys.justPressed.FIVE && Init.trueSettings.get('Debug Info'))
					useNewRanking = !useNewRanking;
			}

			///*
			if (startingSong)
			{
				if (startedCountdown)
				{
					Conductor.songPosition += elapsed * 1000;
					if (Conductor.songPosition >= 0)
						startSong();
				}
			}
			else
			{
				// Conductor.songPosition = FlxG.sound.music.time;
				Conductor.songPosition += elapsed * 1000;

			//	songPositionBar = Conductor.songPosition;

				if(updateTime) {
					var curTime:Float = Conductor.songPosition;
					if(curTime < 0) curTime = 0;
					songPositionBar = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
				//	if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

				//	if(ClientPrefs.timeBarType != 'Song Name')
				//		timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}

				if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;

					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
						// Conductor.songPosition += FlxG.elapsed * 1000;
						// trace('MISSED FRAME');
					}
				}

				// Conductor.lastSongPos = FlxG.sound.music.time;
				// song shit for testing lols
			}

			// boyfriend.playAnim('singLEFT', true);
			// */

			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				var curSection = Std.int(curStep / 16);
				if (curSection != lastSection)
				{
					// section reset stuff
					var lastMustHit:Bool = PlayState.SONG.notes[lastSection].mustHitSection;
					if (PlayState.SONG.notes[curSection].mustHitSection != lastMustHit)
					{
						camDisplaceX = 0;
						camDisplaceY = 0;
					}
					lastSection = Std.int(curStep / 16);
				}

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					var char = dadOpponent;

					var getCenterX = char.getMidpoint().x + 100;
					var getCenterY = char.getMidpoint().y - 100;

					camFollow.setPosition(getCenterX + camDisplaceX + char.characterData.camOffsetX,
						getCenterY + camDisplaceY + char.characterData.camOffsetY);

					if (char.curCharacter == 'mom')
						vocals.volume = 1;
				}
				else
				{
					var char = boyfriend;

					var getCenterX = char.getMidpoint().x - 100;
					var getCenterY = char.getMidpoint().y - 100;
					switch (curStage)
					{
						case 'limo':
							getCenterX = char.getMidpoint().x - 300;
						case 'mall':
							getCenterY = char.getMidpoint().y - 200;
						case 'school':
							getCenterX = char.getMidpoint().x - 200;
							getCenterY = char.getMidpoint().y - 200;
						case 'schoolEvil':
							getCenterX = char.getMidpoint().x - 200;
							getCenterY = char.getMidpoint().y - 200;
					}

					camFollow.setPosition(getCenterX + camDisplaceX - char.characterData.camOffsetX,
						getCenterY + camDisplaceY + char.characterData.camOffsetY);
				}
			}

			var lerpVal = (elapsed * 2.4) * cameraSpeed;
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

			var easeLerp = 0.95;
			// camera stuffs
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom + forceZoom[0], FlxG.camera.zoom, easeLerp);
			for (hud in allUIs)
				hud.zoom = FlxMath.lerp(1 + forceZoom[1], hud.zoom, easeLerp);

			// not even forcezoom anymore but still
			FlxG.camera.angle = FlxMath.lerp(0 + forceZoom[2], FlxG.camera.angle, easeLerp);
			for (hud in allUIs)
				hud.angle = FlxMath.lerp(0 + forceZoom[3], hud.angle, easeLerp);

			// Controls

			// RESET = Quick Game Over Screen
			if (controls.RESET && !startingSong && !isStoryMode)
			{
				forceDeath = true;
			}

			if (((health <= 0 && startedCountdown && !practiceMode) && canDie) || forceDeath)
			{
				paused = true;
				// startTimer.active = false;
				persistentUpdate = false;
				persistentDraw = false;

				resetMusic();

				deaths += 1;

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if DISCORD_RPC
				Discord.changePresence("Game Over - " + songDetails, detailsSub, iconRPC);
				#end
			}

			// spawn in the notes from the array
			if ((unspawnNotes[0] != null) && ((unspawnNotes[0].strumTime - Conductor.songPosition) < 3500))
			{
				var dunceNote:Note = unspawnNotes[0];
				// push note to its correct strumline
				strumLines.members[Math.floor((dunceNote.noteData + (dunceNote.mustPress ? 4 : 0)) / numberOfKeys)].push(dunceNote);
				unspawnNotes.splice(unspawnNotes.indexOf(dunceNote), 1);
			}

			noteCalls();

			if (Init.trueSettings.get('Controller Mode'))
				controllerInput();
		}
	}

	// maybe theres a better place to put this, idk -saw
	function controllerInput()
	{
		var justPressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];

		var justReleaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		if (justPressArray.contains(true))
		{
			for (i in 0...justPressArray.length)
			{
				if (justPressArray[i])
					onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
			}
		}

		if (justReleaseArray.contains(true))
		{
			for (i in 0...justReleaseArray.length)
			{
				if (justReleaseArray[i])
					onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
			}
		}
	}

	function noteCalls()
	{
		// reset strums
		for (strumline in strumLines)
		{
			// handle strumline stuffs
			for (uiNote in strumline.receptors)
			{
				if (strumline.autoplay)
					strumCallsAuto(uiNote);
			}

			if (strumline.splashNotes != null)
				for (i in 0...strumline.splashNotes.length)
				{
					strumline.splashNotes.members[i].x = strumline.receptors.members[i].x - 48;
					strumline.splashNotes.members[i].y = strumline.receptors.members[i].y + (Note.swagWidth / 6) - 56;
				}
		}

		// if the song is generated
		if (generatedMusic && startedCountdown)
		{
			for (strumline in strumLines)
			{
				// set the notes x and y
				var downscrollMultiplier = 1;
				if (Init.trueSettings.get('Downscroll'))
					downscrollMultiplier = -1;

				strumline.allNotes.forEachAlive(function(daNote:Note)
				{
					var roundedSpeed = FlxMath.roundDecimal(daNote.noteSpeed, 2);
					var receptorPosY:Float = strumline.receptors.members[Math.floor(daNote.noteData)].y + Note.swagWidth / 6;
					var psuedoY:Float = (downscrollMultiplier * -((Conductor.songPosition - daNote.strumTime) * (0.45 * roundedSpeed)));
					var psuedoX = 25 + daNote.noteVisualOffset;

					daNote.y = receptorPosY
						+ (Math.cos(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoY)
						+ (Math.sin(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoX);
					// painful math equation
					daNote.x = strumline.receptors.members[Math.floor(daNote.noteData)].x
						+ (Math.cos(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoX)
						+ (Math.sin(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoY);

					// also set note rotation
					daNote.angle = -daNote.noteDirection;

					// shitty note hack I hate it so much
					var center:Float = receptorPosY + Note.swagWidth / 2;
					if (daNote.isSustainNote)
					{
						daNote.y -= ((daNote.height / 2) * downscrollMultiplier);
						if ((daNote.animation.curAnim.name.endsWith('holdend')) && (daNote.prevNote != null))
						{
							daNote.y -= ((daNote.prevNote.height / 2) * downscrollMultiplier);
							if (Init.trueSettings.get('Downscroll'))
							{
								daNote.y += (daNote.height * 2);
								if (daNote.endHoldOffset == Math.NEGATIVE_INFINITY)
								{
									// set the end hold offset yeah I hate that I fix this like this
									daNote.endHoldOffset = (daNote.prevNote.y - (daNote.y + daNote.height));
									trace(daNote.endHoldOffset);
								}
								else
									daNote.y += daNote.endHoldOffset;
							}
							else // this system is funny like that
								daNote.y += ((daNote.height / 2) * downscrollMultiplier);
						}

						if (Init.trueSettings.get('Downscroll'))
						{
							daNote.flipY = true;
							if ((daNote.parentNote != null && daNote.parentNote.wasGoodHit)
								&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
								&& (strumline.autoplay || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;
								daNote.clipRect = swagRect;
							}
						}
						else
						{
							if ((daNote.parentNote != null && daNote.parentNote.wasGoodHit)
								&& daNote.y + daNote.offset.y * daNote.scale.y <= center
								&& (strumline.autoplay || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;
								daNote.clipRect = swagRect;
							}
						}
					}
					// hell breaks loose here, we're using nested scripts!
					mainControls(daNote, strumline.character, strumline, strumline.autoplay);

					// check where the note is and make sure it is either active or inactive
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}

					if (!daNote.tooLate && daNote.strumTime < Conductor.songPosition - (Timings.msThreshold) && !daNote.wasGoodHit)
					{
						if ((!daNote.tooLate) && (daNote.mustPress))
						{
							if (!daNote.isSustainNote)
							{
								daNote.tooLate = true;
								for (note in daNote.childrenNotes)
									note.tooLate = true;

								vocals.volume = 0;
								missNoteCheck((Init.trueSettings.get('Ghost Tapping') || antimashshit) ? true : false, daNote.noteData, boyfriend, true);
								// ambiguous name
								Timings.updateAccuracy(0);
							}
							else if (daNote.isSustainNote)
							{
								if (daNote.parentNote != null)
								{
									var parentNote = daNote.parentNote;
									if (!parentNote.tooLate)
									{
										var breakFromLate:Bool = false;
										for (note in parentNote.childrenNotes)
										{
											trace('hold amount ${parentNote.childrenNotes.length}, note is late?' + note.tooLate + ', ' + breakFromLate);
											if (note.tooLate && !note.wasGoodHit)
												breakFromLate = true;
										}
										if (!breakFromLate)
										{
											missNoteCheck((Init.trueSettings.get('Ghost Tapping') || antimashshit) ? true : false, daNote.noteData, boyfriend, true);
											for (note in parentNote.childrenNotes)
												note.tooLate = true;
										}
										//
									}
								}
							}
						}
					}

					// if the note is off screen (above)
					if ((((!Init.trueSettings.get('Downscroll')) && (daNote.y < -daNote.height))
						|| ((Init.trueSettings.get('Downscroll')) && (daNote.y > (FlxG.height + daNote.height))))
						&& (daNote.tooLate || daNote.wasGoodHit))
						destroyNote(strumline, daNote);
				});

				// unoptimised asf camera control based on strums
				strumCameraRoll(strumline.receptors, (strumline == boyfriendStrums));
			}
		}

		// reset bf's animation
		var holdControls:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		if ((boyfriend != null && boyfriend.animation != null)
			&& (boyfriend.holdTimer > Conductor.stepCrochet * (4 / 1000) && (!holdControls.contains(true) || boyfriendStrums.autoplay)))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.dance();
		}
	}

	function destroyNote(strumline:Strumline, daNote:Note)
	{
		daNote.active = false;
		daNote.exists = false;

		var chosenGroup = (daNote.isSustainNote ? strumline.holdsGroup : strumline.notesGroup);
		// note damage here I guess
		daNote.kill();
		if (strumline.allNotes.members.contains(daNote))
			strumline.allNotes.remove(daNote, true);
		if (chosenGroup.members.contains(daNote))
			chosenGroup.remove(daNote, true);
		daNote.destroy();
	}

	function goodNoteHit(coolNote:Note, character:Character, characterStrums:Strumline, ?canDisplayJudgement:Bool = true)
	{
		if (!coolNote.wasGoodHit)
		{
			coolNote.wasGoodHit = true;
			vocals.volume = 1;

			bopType = 'both';

			characterPlayAnimation(coolNote, character);
			if (characterStrums.receptors.members[coolNote.noteData] != null)
				characterStrums.receptors.members[coolNote.noteData].playAnim('confirm', true);

			// special thanks to sam, they gave me the original system which kinda inspired my idea for this new one
			if (canDisplayJudgement)
			{
				// get the note ms timing
				var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);
				// get the timing
				if (coolNote.strumTime < Conductor.songPosition)
					ratingTiming = "late";
				else
					ratingTiming = "early";

				// loop through all avaliable judgements
				var foundRating:String = 'miss';
				var lowestThreshold:Float = Math.POSITIVE_INFINITY;
				for (myRating in Timings.judgementsMap.keys())
				{
					var myThreshold:Float = Timings.judgementsMap.get(myRating)[1];
					if (noteDiff <= myThreshold && (myThreshold < lowestThreshold))
					{
						foundRating = myRating;
						lowestThreshold = myThreshold;
					}
				}

				bopJudgement();

				forceLose = false;

				if (!coolNote.isSustainNote)
				{
					goodNotePressed = true;
					increaseCombo(foundRating, coolNote.noteData, character);
					popUpScore(foundRating, ratingTiming, characterStrums, coolNote);
					if (Init.trueSettings.get("Hitsounds")) FlxG.sound.play(Paths.sound('hitsound'), 0.7);
					if (coolNote.childrenNotes.length > 0)
						Timings.notesHit++;

					if (Init.trueSettings.get("Back to the Basics")) health += 0.08;
					else health += 0.025;

					if (Init.trueSettings.get("Anti Mash"))
					antimashshit = true;

					if (Init.trueSettings.get("Avali Accurate"))
						fuckYouNoHit = true;

					ClassHUD.bopScore();

					if (!doubleTime && energyig < 100 && !useDefaultForever) energyig += 2;
				}
				else if (coolNote.isSustainNote)
				{
					// call updated accuracy stuffs
					if (coolNote.parentNote != null)
					{
						Timings.updateAccuracy(100, true, coolNote.parentNote.childrenNotes.length);
						healthCall(100 / coolNote.parentNote.childrenNotes.length);
						if (!doubleTime && energyig < 100 && !useDefaultForever) energyig += 0.1;
					}
				}
			} else {
				switch (dadOpponent.curCharacter) {
					case 'monster','monster-christmas':
						if (health > 0.5) health -= healthToLower;
					case 'bf','bf-pixel','bf-car','bf-christmas':
						if (health > 0.1 && !coolNote.isSustainNote) health -= 0.025;
				}
				if (curSong.toLowerCase() == 'anomaly' || curSong.toLowerCase() == 'cheating') {
					if (!coolNote.isSustainNote && !Init.trueSettings.get("Reduced Movements")) camHUD.angle = FlxG.random.int(-30, 30);
					health -= healthToLower;
				}
				if (curSong.toLowerCase() == 'thearchy') {
					canDie = false;
					if (health > 0.7)
					health -= healthToLower;
				}
				if (curSong.toLowerCase() == 'vac') {
					if (!Init.trueSettings.get("Reduced Movements") && misses >= 1)	camHUD.shake(0.003, 0.1);
					health -= healthToLower;
				}
				if (curSong.toLowerCase() == 'ataefull') {
					if (!coolNote.isSustainNote && health > 0.1) health -= healthToLower;
				}
				if (Init.trueSettings.get('Stage Fright') && healthToLower == 0 && health > 0.1) health -= 0.01;
				if (!coolNote.isSustainNote) {
					opponentSploosh(coolNote, characterStrums);
				}
			}

			if (!coolNote.isSustainNote)
				destroyNote(characterStrums, coolNote);
			//
		}
	}

	function missNoteCheck(?includeAnimation:Bool = false, direction:Int = 0, character:Character, popMiss:Bool = false, lockMiss:Bool = false, ?ghostTapFail:Bool = false)
	{
		if (includeAnimation)
		{
			var stringDirection:String = UIStaticArrow.getArrowFromNumber(direction);

			if (health >= 0.1) {
			FlxG.sound.play(Paths.soundRandom('hurt/missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			switch (boyfriend.curCharacter) {
				case 'bf-og':
					// BOYFRIEND IS FUCKING LAME LMAOOOOO
				case 'poptop':
					FlxG.sound.play(Paths.sound('hurt/poptop_notice1'), 0.7);
				case 'ryan','ryan-car','ryan-christmas','ryan-pixel':
					FlxG.sound.play(Paths.sound('hurt/avalihurt'), 0.7);
				case 'connor','connor-car','connor-christmas','connor-pixel':
					FlxG.sound.play(Paths.sound('hurt/connorhurt'), 0.7);
				case 'ian','ian-player','ian-car','ian-christmas','ian-pixel':
					FlxG.sound.play(Paths.sound('hurt/hylotlhurt'), 0.7);
				default:
					
			}}
			character.playAnim('sing' + stringDirection.toUpperCase() + 'miss', lockMiss);

			if (ghostTapFail || songScore <= 0) {
			character.playAnim('ghostMiss', lockMiss);
			FlxG.sound.play(Paths.sound('hurt/ghostMiss'), 0.7);
			}

			forceLose = true;
		}
		judgementText.text = 'Miss\nx$combo';
		bopJudgement();
		decreaseCombo(popMiss);

		//
	}

	function characterPlayAnimation(coolNote:Note, character:Character)
	{
		// alright so we determine which animation needs to play
		// get alt strings and stuffs
		var stringArrow:String = '';
		var altString:String = '';

		var baseString = 'sing' + UIStaticArrow.getArrowFromNumber(coolNote.noteData).toUpperCase();

		// I tried doing xor and it didnt work lollll
		if (coolNote.noteAlt > 0)
			altString = '-alt';
		if (((SONG.notes[Math.floor(curStep / 16)] != null) && (SONG.notes[Math.floor(curStep / 16)].altAnim))
			&& (character.animOffsets.exists(baseString + '-alt')))
		{
			if (altString != '-alt')
				altString = '-alt';
			else
				altString = '';
		}

		stringArrow = baseString + altString;
		// if (coolNote.foreverMods.get('string')[0] != "")
		//	stringArrow = coolNote.noteString;

		character.playAnim(stringArrow, true);
		character.holdTimer = 0;
	}

	private function strumCallsAuto(cStrum:UIStaticArrow, ?callType:Int = 1, ?daNote:Note):Void
	{
		switch (callType)
		{
			case 1:
				// end the animation if the calltype is 1 and it is done
				if ((cStrum.animation.finished) && (cStrum.canFinishAnimation))
					cStrum.playAnim('static');
			default:
				// check if it is the correct strum
				if (daNote.noteData == cStrum.ID)
				{
					// if (cStrum.animation.curAnim.name != 'confirm')
					cStrum.playAnim('confirm'); // play the correct strum's confirmation animation (haha rhymes)

					// stuff for sustain notes
					if ((daNote.isSustainNote) && (!daNote.animation.curAnim.name.endsWith('holdend')))
						cStrum.canFinishAnimation = false; // basically, make it so the animation can't be finished if there's a sustain note below
					else
						cStrum.canFinishAnimation = true;
				}
		}
	}

	private function mainControls(daNote:Note, char:Character, strumline:Strumline, autoplay:Bool):Void
	{
		var notesPressedAutoplay = [];

		// here I'll set up the autoplay functions
		if (autoplay)
		{
			// check if the note was a good hit
			if (daNote.strumTime <= Conductor.songPosition)
			{
				// use a switch thing cus it feels right idk lol
				// make sure the strum is played for the autoplay stuffs
				/*
					charStrum.forEach(function(cStrum:UIStaticArrow)
					{
						strumCallsAuto(cStrum, 0, daNote);
					});
				 */

				// kill the note, then remove it from the array
				var canDisplayJudgement = false;
				if (strumline.displayJudgements)
				{
					canDisplayJudgement = true;
					for (noteDouble in notesPressedAutoplay)
					{
						if (noteDouble.noteData == daNote.noteData)
						{
							// if (Math.abs(noteDouble.strumTime - daNote.strumTime) < 10)
							canDisplayJudgement = false;
							// removing the fucking check apparently fixes it
							// god damn it that stupid glitch with the double judgements is annoying
						}
						//
					}
					notesPressedAutoplay.push(daNote);
				}
				goodNoteHit(daNote, char, strumline, canDisplayJudgement);
			}
			//
		}

		var holdControls:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		if (!autoplay)
		{
			// check if anything is held
			if (holdControls.contains(true))
			{
				// check notes that are alive
				strumline.allNotes.forEachAlive(function(coolNote:Note)
				{
					if ((coolNote.parentNote != null && coolNote.parentNote.wasGoodHit)
						&& coolNote.canBeHit
						&& coolNote.mustPress
						&& !coolNote.tooLate
						&& coolNote.isSustainNote
						&& holdControls[coolNote.noteData])
						goodNoteHit(coolNote, char, strumline);
				});
			}
		}
	}

	private function strumCameraRoll(cStrum:FlxTypedGroup<UIStaticArrow>, mustHit:Bool)
	{
		if (!Init.trueSettings.get('No Camera Note Movement'))
		{
			var camDisplaceExtend:Float = 15;
			if (PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if ((PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && mustHit)
					|| (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !mustHit))
				{
					camDisplaceX = 0;
					if (cStrum.members[0].animation.curAnim.name == 'confirm')
						camDisplaceX -= camDisplaceExtend;
					if (cStrum.members[3].animation.curAnim.name == 'confirm')
						camDisplaceX += camDisplaceExtend;

					camDisplaceY = 0;
					if (cStrum.members[1].animation.curAnim.name == 'confirm')
						camDisplaceY += camDisplaceExtend;
					if (cStrum.members[2].animation.curAnim.name == 'confirm')
						camDisplaceY -= camDisplaceExtend;
				}
			}
		}
		//
	}

	public function pauseGame()
	{
		// pause discord rpc
		updateRPC(true);

		// pause game
		paused = true;

		// update drawing stuffs
		persistentUpdate = false;
		persistentDraw = true;

		// open pause substate
		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}

	override public function onFocus():Void
	{
		if (!paused)
			updateRPC(false);
		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (canPause && !paused && !Init.trueSettings.get('Auto Pause'))
			pauseGame();
		super.onFocusLost();
	}

	public static function updateRPC(pausedRPC:Bool)
	{
		#if DISCORD_RPC
		var displayRPC:String = (pausedRPC) ? detailsPausedText : songDetails;

		if (health > 0)
		{
			if (Conductor.songPosition > 0 && !pausedRPC)
				Discord.changePresence(displayRPC, detailsSub, iconRPC, true, songLength - Conductor.songPosition);
			else
				Discord.changePresence(displayRPC, detailsSub, iconRPC);
		}
		#end
	}

	var animationsPlay:Array<Note> = [];

	private var ratingTiming:String = "";

	function popUpScore(baseRating:String, timing:String, strumline:Strumline, coolNote:Note)
	{
		// set up the rating
		var score:Int = 50;

		// notesplashes
		if (baseRating == "sick")
			// create the note splash if you hit a sick
			createSplash(coolNote, strumline);
		else {
			// if it isn't a sick, and you had a sick combo, then it becomes not sick :(
			if (allSicks)
				allSicks = false;
			messups++;
		}

		if (baseRating == 'miss' && goodNotePressed) // just so hitting a note extremely early/late won't give a miss
		displayRating("shit", timing);	
		else
		displayRating(baseRating, timing);

		Timings.updateAccuracy(Timings.judgementsMap.get(baseRating)[3]);
		if (!cpuControlled) {
		score = Std.int(Timings.judgementsMap.get(baseRating)[2]);
		songScore += (doubleTime == true ? (score * 2) : score);
		} else songScore = 0;

		popUpCombo();
	}

	function opponentSploosh(coolNote:Note, strumline:Strumline) {
		// play animation in existing notesplashes
		var noteSplashRandom:String = (Std.string((FlxG.random.int(0, 1) + 1)));
		if (strumline.splashNotes != null)
			strumline.splashNotes.members[coolNote.noteData].playAnim('anim' + noteSplashRandom, true);
	}

	public function createSplash(coolNote:Note, strumline:Strumline)
	{
		// play animation in existing notesplashes
		var noteSplashRandom:String = (Std.string((FlxG.random.int(0, 1) + 1)));
		if (strumline.splashNotes != null)
			strumline.splashNotes.members[coolNote.noteData].playAnim('anim' + noteSplashRandom, true);
	}

	private var createdColor = FlxColor.fromRGB(204, 66, 66);

	function popUpCombo(?cache:Bool = false)
	{
		if (useDefaultForever || isPixelStage) {
		var comboString:String = Std.string(combo);
		var negative = false;
		if ((comboString.startsWith('-')) || (combo == 0))
			negative = true;
		var stringArray:Array<String> = comboString.split("");
		// deletes all combo sprites prior to initalizing new ones
		if (lastCombo != null)
		{
			while (lastCombo.length > 0)
			{
				lastCombo[0].kill();
				lastCombo.remove(lastCombo[0]);
			}
		}

		for (scoreInt in 0...stringArray.length)
		{
			// numScore.loadGraphic(Paths.image('UI/' + pixelModifier + 'num' + stringArray[scoreInt]));
			var numScore = ForeverAssets.generateCombo('combo', stringArray[scoreInt], (!negative ? allSicks : false), assetModifier, changeableSkin, 'UI',
				negative, createdColor, scoreInt);
			add(numScore);
			// hardcoded lmao
				add(numScore);
				// centers combo
				numScore.y += 10;
				numScore.x -= 95;
				numScore.x -= ((comboString.length - 1) * 22);
				lastCombo.push(numScore);
				FlxTween.tween(numScore, {y: numScore.y + 20}, 0.1, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
				FlxTween.tween(numScore, {"scale.x": 0, "scale.y": 0}, 0.1, {
					onComplete: function(tween:FlxTween)
					{
						numScore.kill();
					},
					startDelay: Conductor.crochet * 0.00125
				});
			// hardcoded lmao
				if (!cache)
					numScore.cameras = [camHUD];
				numScore.y += 50;
			numScore.x += 100;
		}}
	}

	function decreaseCombo(?popMiss:Bool = false)
	{
		goodNotePressed = false;
		// painful if statement
		if (((combo > 5) || (combo < 0)) && (gf.animOffsets.exists('sad')))
			gf.playAnim('sad');

	

		if (Init.trueSettings.get('FC Mode')) health = -9;

		if (fuckingRankText == 'p') fuckingRankText = 's';

		forceLose = true;

		energyig -= 20;

		actualMisses++;

		if (energyig <= 0) {
			if (combo > 0) {
				combo = 0; // bitch lmao
				FlxG.sound.play(Paths.sound('combo/end'));
			}
			else
				combo--;

			// misses
			songScore -= 500;
			misses++;
			messups++;
		}

		if (curSong.toLowerCase() == 'vac')
			{
				FlxG.camera.flash(FlxColor.RED, 0.15);

				FlxG.sound.play(Paths.soundRandom('huh/powerup', 1, 2), 1);
			}

		// display negative combo
		if (popMiss)
		{
			// doesnt matter miss ratings dont have timings
			displayRating("miss", 'late');

			if (Init.trueSettings.get("Avali Accurate"))
			health -= 0.01;
			else if (Init.trueSettings.get("Back to the Basics"))
			health -= 0.1;
			else
			health -= 0.05;
		}
		popUpCombo();

		// gotta do it manually here lol
		Timings.updateFCDisplay();

		owwhyyouhurtme();
	}

	function increaseCombo(?baseRating:String, ?direction = 0, ?character:Character)
	{
		// trolled this can actually decrease your combo if you get a bad/shit/miss
		if (baseRating != null)
		{
			if (Timings.judgementsMap.get(baseRating)[latedamage] > 0)
			{
				if (combo < 0)
					combo = 0;
				combo += (doubleTime == true ? 2 : 1);
			}
			else
				missNoteCheck(true, direction, character, false, true);
		}
	}

	public function displayRating(daRating:String, timing:String, ?cache:Bool = false)
	{
		/* so you might be asking
			"oh but if the rating isn't sick why not just reset it"
			because miss judgements can pop, and they dont mess with your sick combo
		 */

		var rating = ForeverAssets.generateRating('$daRating', (daRating == 'sick' ? allSicks : false), timing, assetModifier, changeableSkin, 'UI');
		if (useDefaultForever || isPixelStage)
		add(rating);


			if (lastRating != null)
			{
				lastRating.kill();
			}
			if (useDefaultForever || isPixelStage)
			add(rating);
			lastRating = rating;
			FlxTween.tween(rating, {y: rating.y + 20}, 0.2, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
			FlxTween.tween(rating, {"scale.x": 0, "scale.y": 0}, 0.1, {
				onComplete: function(tween:FlxTween)
				{
					rating.kill();
				},
				startDelay: Conductor.crochet * 0.00125
			});
		// */

		if (!cache)
		{
				// bound to camera
				rating.cameras = [camHUD];
				rating.screenCenter();

			// return the actual rating to the array of judgements
			Timings.gottenJudgements.set(daRating, Timings.gottenJudgements.get(daRating) + 1);

			// set new smallest rating
			if (Timings.smallestRating != daRating)
			{
				if (Timings.judgementsMap.get(Timings.smallestRating)[0] < Timings.judgementsMap.get(daRating)[0])
					Timings.smallestRating = daRating;
			}
			if (!useDefaultForever && !isPixelStage) {
			var stupidRating:String = '?';
			judgementText.color = 0xFFFFFFFF;
			switch (daRating) {
				case 'sick','sick-early','sick-late':
					stupidRating = 'Sick!!';
					if (allSicks) {
						judgementText.color = 0xFFFFEBBE;
						stupidRating = 'NICE ONE!!';
					}
				case 'good','good-early','good-late':
					stupidRating = 'Meh';
				case 'bad','bad-early','bad-late':
					stupidRating = 'Okay?';
				case 'shit','shit-early','shit-late':
					stupidRating = 'Trash';
				case 'miss','miss-early','miss-late':
					stupidRating = 'Miss';
					judgementText.color = 0xFFFF3D3A;
			}
			judgementText.text = '$stupidRating\nx$combo\n';
			bopJudgement();
			} else judgementText.visible = false;
		}
	}

	function healthCall(?ratingMultiplier:Float = 0)
	{
		// health += 0.012;
		var healthBase:Float = 0.06;
		health += (healthBase * (ratingMultiplier / 100) * (doubleTime == true ? 2 : 1));
	}

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			songMusic.play();
			songMusic.onComplete = endSong;
			vocals.play();

			resyncVocals();

			#if desktop
			// Song duration in a float, useful for the time left feature
			songLength = songMusic.length;

			// Updating Discord Rich Presence (with Time Left)
			updateRPC(false);
			#end
		}
	}

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (Init.trueSettings.get('Debug Info'))
			songDetails = 'NO LEAKS! - Rank: ' + fuckingRankText.toUpperCase();
		else
		songDetails = CoolUtil.dashToSpace(SONG.song) + ' - Rank: ' + fuckingRankText.toUpperCase();

		// String for when the game is paused
		detailsPausedText = "Paused - " + songDetails;

		// set details for song stuffs
		detailsSub = "";

		// Updating Discord Rich Presence.
		updateRPC(false);

		curSong = songData.song;
		songMusic = new FlxSound().loadEmbedded(Paths.inst(SONG.song), false, true);

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song), false, true);
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(songMusic);
		FlxG.sound.list.add(vocals);

		// generate the chart
		unspawnNotes = ChartLoader.generateChartType(SONG, determinedChartType);
		// sometime my brain farts dont ask me why these functions were separated before

		// sort through them
		unspawnNotes.sort(sortByShit);
		// give the game the heads up to be able to start
		generatedMusic = true;
	}

	function owwhyyouhurtme() {
		var missesRequired:Int = 20;
		var daCharacter:String = 'RYAN';
		if (FreeplayState.characterOverrides == 'connor' || boyfriend.curCharacter == 'ironlord') missesRequired = 1;

		switch (FreeplayState.characterOverrides) {
			case 'connor':
				daCharacter = 'CONNOR';
			case 'ian-player','ian':
				daCharacter = 'IAN';
			case 'carson':
				daCharacter = 'CARSON';
			case 'bf':
				daCharacter = 'BOYFRIEND';
			default:
				daCharacter = 'RYAN';
		}

		switch (boyfriend.curCharacter) {
			case 'connor':
				daCharacter = 'CONNOR';
			case 'bf':
				daCharacter = 'BOYFRIEND';
			case 'ian-player','ian':
				daCharacter = 'IAN';
			case 'poptop':
				daCharacter = 'THE POPTOP';
			case 'eilyo':
				daCharacter = 'EILYO';
			case 'ironlord':
				daCharacter = 'IRONLORD';
		}

		if (misses % missesRequired == 0 && misses != 0) {
			hurtText.text = 'YOU\'VE HURT $daCharacter $misses TIMES';
			displayMidText();
		}
	}

	function displayMidText() {
		hurtText.alpha = 1;
		hurtText.screenCenter(X);
		FlxTween.cancelTweensOf(hurtText);
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);

	function resyncVocals():Void
	{
		trace('resyncing vocal time ${vocals.time}');
		songMusic.pause();
		vocals.pause();
		Conductor.songPosition = songMusic.time;
		vocals.time = Conductor.songPosition;
		songMusic.play();
		vocals.play();
		trace('new vocal time ${Conductor.songPosition}');
	}

	var bopbopbop:Bool = false;
	var sidetoSide = false;

	override function stepHit()
	{
		super.stepHit();

		if (curStep == 1) {
			ClassHUD.fadeInSongText();
			FlxTween.tween(songPosBG, {alpha: 1}, 1, {ease: FlxEase.linear});
			FlxTween.tween(songPosBar, {alpha: 1}, 1, {ease: FlxEase.linear});
		}

		theSongStuff.text = 'Song: ${SONG.song}\ncurBeat: $curBeat\ncurStep: $curStep\nBPM: ${SONG.bpm}\n';

		switch (curSong.toLowerCase()) {
			case 'mirage':
				switch (curStep) {
					case 896:
						FlxTween.tween(blackBG, {alpha: 1}, 1, {ease: FlxEase.linear});
						FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.linear});
					case 906:
					//	eventTrigger('changeScroll','slow','');
						stageBuild.stageShit('litspace');
						boyfriend.color = 0xFF71104B;
						dadOpponent.color = 0xFF71104B;
						gf.color = 0xFF71104B;
					case 920:
						FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.linear});
					case 928:
						FlxTween.tween(blackBG, {alpha: 0}, 1, {ease: FlxEase.linear});
						// space transition
				}
			case 'thearchy':
				camHUD.angle = FlxG.random.int(-5, 5);
			case 'awaken':
				health -= 0.007 + ((misses + messups) * 0.001);
			case 'wtf':
				switch (curStep) {
					case 64,640:
						bopbopbop = true;
					case 384,1280:
						bopbopbop = false;
					case 624,628,632,634:
						forceBop();
				}
			case 'ataefull':
				switch (curStep) {
					case 2,4,6,8,10,12:
						bopType = 'none';
					case 191:
						bopType = 'tween';
					case 2560,3792:
						idotChanged = true;
						changePlayer();
					case 3392:
						idotChanged = false;
						changePlayer();
					case 3520:
						FlxG.camera.flash(FlxColor.WHITE, 3);
						blackBG.alpha = 1;
					case 3664:
						FlxTween.tween(blackBG, {alpha: 0}, 5, {ease: FlxEase.linear});
					case 3728:
						FlxG.camera.flash(FlxColor.WHITE, 3);
						health = 1;
						startRound2();
						bopbopbop = true;
					case 4304:
						FlxG.camera.flash(FlxColor.WHITE, 3);
						bopbopbop = false;
				}
			case 'epitome':
					switch (curStep) {
						case 128,384,896:
							sidetoSide = true;
						case 256,512,1024:
							sidetoSide = false;
						case 260,516,1028:
							camHUD.angle = 0;
					}
		}

		///*
		if (songMusic.time >= Conductor.songPosition + 20 || songMusic.time <= Conductor.songPosition - 20)
			resyncVocals();
		//*/
	}

	var beatthing:Int = 2;
	private function charactersDance(curBeat:Int)
	{
		if (hasTWOplayers) beatthing = 1;
		else beatthing = 2;

		if ((curBeat % gfSpeed == 0) && ((gf.animation.curAnim.name.startsWith("idle") || gf.animation.curAnim.name.startsWith("dance"))))
			gf.dance();

		if ((boyfriend.animation.curAnim.name.startsWith("idle") || boyfriend.animation.curAnim.name.startsWith("dance"))
			&& (curBeat % beatthing == 0 || boyfriend.characterData.quickDancer)) {
			forceLose = false;
			boyfriend.dance();
			}

		// added this for opponent cus it wasn't here before and skater would just freeze
		if ((dadOpponent.animation.curAnim.name.startsWith("idle") || dadOpponent.animation.curAnim.name.startsWith("dance"))
			&& (curBeat % beatthing == 0 || dadOpponent.characterData.quickDancer))
			dadOpponent.dance();
	}

	var betweenstuff:Bool = false;
	function forceBop() {
		betweenstuff = !betweenstuff;
		if (bopType == 'both' || (bopType == 'tween' && betweenstuff == true))
		FlxG.camera.zoom += 0.015;
		if (bopType == 'both' || (bopType == 'tween' && betweenstuff == false)) {
		camHUD.zoom += 0.05;
		for (hud in strumHUD)
			hud.zoom += 0.05;
		}
	}

	function changePlayer(?idiot:String = 'connor') {
		if (idotChanged) {
			remove(bftwobutfake);
			bfbutfake = new Character();
			bfbutfake.setCharacter(750, 850, SONG.player1);
			bfbutfake.flipX = false;
			add(bfbutfake);
			boyfriend.setCharacter(1050,850, idiot);
			boyfriend.flipX = false;
			iconP1.updateIcon(idiot, true);
		} else {
			remove(bfbutfake);
			boyfriend.setCharacter(750, 850, SONG.player1);
			boyfriend.flipX = false;
			bftwobutfake = new Character(); // switch bf
			bftwobutfake.setCharacter(1050,850, idiot);
			add(bftwobutfake);
			iconP1.updateIcon(SONG.player1, true);
		}
	}

	function startRound2() {
		songScore = (Math.floor(songScore * 1.2));
		FlxG.sound.play(Paths.sound('lap2'), 1);
		roundTwoCompleted = true;
		FlxTween.tween(round2Text, {y: 100}, 2, {ease: FlxEase.linear});
	}

	override function beatHit()
	{
		super.beatHit();

		antimashshit = false;

		if (curBeat % 4 == 0 && hurtText.alpha == 1)
			FlxTween.tween(hurtText, {alpha: 0}, 2, {ease: FlxEase.linear});

		if (curBeat % 4 == 0 && round2Text.y == 100)
			FlxTween.tween(round2Text, {y: -200}, 2, {ease: FlxEase.linear});

		if (hasTWOplayers) {
		bftwobutfake.animation.play('idle');
		bfbutfake.animation.play('idle');
		}

		if (isPixelStage) {
			if (curBeat % 1 == 0)
				currentColor = 0xFFFF0C0C;
			if (curBeat % 2 == 0)
				currentColor = 0xFFFF9B0C;
			if (curBeat % 3 == 0)
				currentColor = 0xFFFFFC0C;
			if (curBeat % 4 == 0)
				currentColor = 0xFF12FF0C;
			if (curBeat % 5 == 0)
				currentColor = 0xFF0CFFF6;
			if (curBeat % 6 == 0)
				currentColor = 0xFF0C90FF;
			if (curBeat % 7 == 0)
				currentColor = 0xFFA60CFF;
			if (curBeat % 8 == 0)
				currentColor = 0xFFFF0FD4;
		}

		fuckYouNoHit = false;

		if (Init.trueSettings.get('Icon Bop') && (!isPixelStage || choosenfont == 'minecraft.otf'))
			{
				iconP1.setGraphicSize(Std.int(iconP1.width + 30));
				iconP2.setGraphicSize(Std.int(iconP2.width + 30));

				if (!useDefaultForever) {
				FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1500 * gfSpeed, {ease: FlxEase.quadOut});
				FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1500 * gfSpeed, {ease: FlxEase.quadOut});
				}

			/*	if (curBeat % 2 == 0) {
				if (health >= 0.4) FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1150 * gfSpeed, {ease: FlxEase.quadOut});
				if (health <= 1.6) FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1150 * gfSpeed, {ease: FlxEase.quadOut});
				}
				else {
				if (health >= 0.4) FlxTween.angle(iconP1, 15, 0, Conductor.crochet / 1150 * gfSpeed, {ease: FlxEase.quadOut});
				if (health <= 1.6) FlxTween.angle(iconP2, -15, 0, Conductor.crochet / 1150 * gfSpeed, {ease: FlxEase.quadOut});
				}*/
	
				iconP1.updateHitbox();
				iconP2.updateHitbox();
			}

		if (FlxG.camera.zoom < 1.35 && bopbopbop && (!Init.trueSettings.get('Reduced Movements')))
			forceBop();

		if (Stage.floatyDad) {
			FlxTween.cancelTweensOf(dadOpponent);
			if (curBeat % 2 == 0)
			FlxTween.tween(dadOpponent, {y: 950}, 1, {ease: FlxEase.cubeOut});
			if (curBeat % 4 == 0)
			FlxTween.tween(dadOpponent, {y: 650}, 1, {ease: FlxEase.cubeOut});
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
			}
		}

		//
		charactersDance(curBeat);

		// stage stuffs
		stageBuild.stageUpdate(curBeat, boyfriend, gf, dadOpponent);

		if (sidetoSide) {
			if (curBeat % 2 == 0) {
				FlxTween.tween(camHUD, {"angle": 5}, Conductor.stepCrochet / 1000, {ease: FlxEase.circInOut});
			}
			else {
				FlxTween.tween(camHUD, {"angle": -5}, Conductor.stepCrochet / 1000, {ease: FlxEase.circInOut});
			}
		}

		if (curSong.toLowerCase() == 'bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}

		if (curSong.toLowerCase() == 'fresh')
		{
			switch (curBeat)
			{
				case 16 | 80:
					gfSpeed = 2;
				case 48 | 112:
					gfSpeed = 1;
			}
		}

		if (curBeat == 16)
			ClassHUD.fadeOutSongText();

		if (curSong.toLowerCase() == 'milf'
			&& curBeat >= 168
			&& curBeat < 200
			&& !Init.trueSettings.get('Reduced Movements')
			&& FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			for (hud in allUIs)
				hud.zoom += 0.03;
		}
	}

	//
	//
	/// substate stuffs
	//
	//

	public static function resetMusic()
	{
		// simply stated, resets the playstate's music for other states and substates
		if (songMusic != null)
			songMusic.stop();

		if (vocals != null)
			vocals.stop();
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			// trace('null song');
			if (songMusic != null)
			{
				//	trace('nulled song');
				songMusic.pause();
				vocals.pause();
				//	trace('nulled song finished');
			}

			// trace('ui shit break');
			if ((startTimer != null) && (!startTimer.finished))
				startTimer.active = false;
		}

		// trace('open substate');
		super.openSubState(SubState);
		// trace('open substate end ');
	}

	function bopJudgement() {
		judgementText.alpha = 1;
		judgementText.screenCenter(X);
		judgementText.scale.set(1.075, 1.075);
		FlxTween.cancelTweensOf(judgementText);
		FlxTween.tween(judgementText, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
		FlxTween.tween(judgementText, {alpha: 0}, 1, {ease: FlxEase.linear});
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (songMusic != null && !startingSong)
				resyncVocals();

			if ((startTimer != null) && (!startTimer.finished))
				startTimer.active = true;
			paused = false;

			///*
			updateRPC(false);
			// */
		}

		Paths.clearUnusedMemory();

		super.closeSubState();
	}

	/*
		Extra functions and stuffs
	 */
	/// song end function at the end of the playstate lmao ironic I guess
	private var endSongEvent:Bool = false;

	function endSong():Void
	{
		if (Math.floor(Timings.getAccuracy() * 100) >= 99.99 && noLap2 && !cpuControlled && songScore >= 1050) // If you got a 100% accuracy yet not enough score you've be givin a P rank anyway
			if (misses == 0 || Init.trueSettings.get("Avali Accurate"))
			fuckingRankText = 'p';

		if (Init.trueSettings.get("P Ranks Only") && fuckingRankText != 'p')
			health -= 69;

		canPause = false;
		songMusic.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);

		deaths = 0;
		daAdmin = 'ryan';

		totalSongs++;
		campaignAccuracy += (Math.floor(Timings.getAccuracy() * 100) / 100);
		actualAccuracy = ((Math.floor(Timings.getAccuracy() * 100) / 100) / totalSongs);

		// set the campaign's score higher
		campaignScore += songScore;
		totalMisses += misses;

		if (!inChart) {
		if (!isStoryMode)
		{
		//	if (Init.trueSettings.get("Debug Info"))
			switch (Init.trueSettings.get('Ranking Screen')) {
			case 'Alt':
				Main.switchState(this, new RankingState());
			case 'Old':
				Main.switchState(this, new OLDRankingState());
			default:
				Main.switchState(this, new RankingStateAlt());
			}
		//	else
		//	Main.switchState(this, new FreeplayState());
		}
		else
		{
			// remove a song from the story playlist
			storyPlaylist.remove(storyPlaylist[0]);

			// check if there aren't any songs left
			if ((storyPlaylist.length <= 0) && (!endSongEvent))
			{
				// play menu music
				ForeverTools.resetMenuMusic();

				// set up transitions
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// change to the menu state
				Main.switchState(this, new RankingState());

				// save the week's score if the score is valid
				if (SONG.validScore)
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

				// flush the save
				FlxG.save.flush();
			}
			else
				songEndSpecificActions();
		}
		} else {
			Main.switchState(this, new OriginalChartingState());
		}
		//
	}

	public function eventTrigger(?type:String = '', ?var1:String = '', ?var2:String = '') { // events demo
		if (type == 'changeScroll') {
			if(var1 == 'fast')
				SONG.speed = SONG.speed += 1;
			if (var1 == 'slow')
				SONG.speed = SONG.speed -= 1;
			if (var1 == 'vslow')
				SONG.speed = SONG.speed -= 2;
			if (var1 == 'vfast')
				SONG.speed = SONG.speed += 2;
		}
	}

	private function songEndSpecificActions()
	{
		switch (SONG.song.toLowerCase())
		{
			case 'eggnog':
				// make the lights go out
				var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
					-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				blackShit.scrollFactor.set();
				add(blackShit);
				camHUD.visible = false;

				// oooo spooky
				FlxG.sound.play(Paths.sound('Lights_Shut_off'));

				// call the song end
				var eggnogEndTimer:FlxTimer = new FlxTimer().start(Conductor.crochet / 1000, function(timer:FlxTimer)
				{
					callDefaultSongEnd();
				}, 1);

			default:
				callDefaultSongEnd();
		}
	}

	private function callDefaultSongEnd()
	{
		var difficulty:String = '-' + CoolUtil.difficultyFromNumber(storyDifficulty).toLowerCase();
		difficulty = difficulty.replace('-normal', '');

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		ForeverTools.killMusic([songMusic, vocals]);

		// deliberately did not use the main.switchstate as to not unload the assets
		FlxG.switchState(new PlayState());
	}

	var dialogueBox:DialogueBox;

	public function songIntroCutscene()
	{
		switch (curSong.toLowerCase())
		{
			case "winter-horrorland":
				inCutscene = true;
				var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				add(blackScreen);
				blackScreen.scrollFactor.set();
				camHUD.visible = false;

				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					remove(blackScreen);
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					camFollow.y = -2050;
					camFollow.x += 200;
					FlxG.camera.focusOn(camFollow.getPosition());
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				});
			case 'roses':
				// the same just play angery noise LOL
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
				callTextbox();
			case 'thorns':
				inCutscene = true;
				for (hud in allUIs)
					hud.visible = false;

				var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
				red.scrollFactor.set();

				var senpaiEvil:FlxSprite = new FlxSprite();
				senpaiEvil.frames = Paths.getSparrowAtlas('cutscene/senpai/senpaiCrazy');
				senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
				senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
				senpaiEvil.scrollFactor.set();
				senpaiEvil.updateHitbox();
				senpaiEvil.screenCenter();

				add(red);
				add(senpaiEvil);
				senpaiEvil.alpha = 0;
				new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
				{
					senpaiEvil.alpha += 0.15;
					if (senpaiEvil.alpha < 1)
						swagTimer.reset();
					else
					{
						senpaiEvil.animation.play('idle');
						FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
						{
							remove(senpaiEvil);
							remove(red);
							FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
							{
								for (hud in allUIs)
									hud.visible = true;
								callTextbox();
							}, true);
						});
						new FlxTimer().start(3.2, function(deadTime:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
						});
					}
				});
			default:
				callTextbox();
		}
		//
	}

	function callTextbox()
	{
		var dialogPath = Paths.json(SONG.song.toLowerCase() + '/dialogue');
		if (sys.FileSystem.exists(dialogPath))
		{
			startedCountdown = false;

			dialogueBox = DialogueBox.createDialogue(sys.io.File.getContent(dialogPath));
			dialogueBox.cameras = [dialogueHUD];
			dialogueBox.whenDaFinish = startCountdown;

			add(dialogueBox);
		}
		else
			startCountdown();
	}

	public static function skipCutscenes():Bool
	{
		// pretty messy but an if statement is messier
		if (Init.trueSettings.get('Skip Text') != null && Std.isOfType(Init.trueSettings.get('Skip Text'), String))
		{
			switch (cast(Init.trueSettings.get('Skip Text'), String))
			{
				case 'never':
					return false;
				case 'freeplay only':
					if (!isStoryMode)
						return true;
					else
						return false;
				default:
					return true;
			}
		}
		return false;
	}

	public static var swagCounter:Int = 0;

	private function startCountdown():Void
	{
		inCutscene = false;
		Conductor.songPosition = -(Conductor.crochet * 5);
		swagCounter = 0;

		camHUD.visible = true;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			startedCountdown = true;

			charactersDance(curBeat);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', [
				ForeverTools.returnSkinAsset('3', assetModifier, changeableSkin, 'UI'),
				ForeverTools.returnSkinAsset('ready', assetModifier, changeableSkin, 'UI'),
				ForeverTools.returnSkinAsset('set', assetModifier, changeableSkin, 'UI'),
				ForeverTools.returnSkinAsset('go', assetModifier, changeableSkin, 'UI')
			]);

			var introAlts:Array<String> = introAssets.get('default');
			for (value in introAssets.keys())
			{
				if (value == PlayState.curStage)
					introAlts = introAssets.get(value);
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('countdowns/$assetModifier/intro3'), 0.6);
					Conductor.songPosition = -(Conductor.crochet * 4);

					if (isPixelStage) {
						var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						three.scrollFactor.set();
						three.updateHitbox();

						three.setGraphicSize(Std.int(three.width * PlayState.daPixelZoom));

						three.screenCenter();
						add(three);

						FlxTween.tween(three, {y: three.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								three.destroy();
							}
						});
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (assetModifier == 'pixel')
						ready.setGraphicSize(Std.int(ready.width * PlayState.daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('countdowns/$assetModifier/intro2'), 0.6);

					Conductor.songPosition = -(Conductor.crochet * 3);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					set.scrollFactor.set();

					if (assetModifier == 'pixel')
						set.setGraphicSize(Std.int(set.width * PlayState.daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('countdowns/$assetModifier/intro1'), 0.6);

					Conductor.songPosition = -(Conductor.crochet * 2);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[3]));
					go.scrollFactor.set();

					if (assetModifier == 'pixel')
						go.setGraphicSize(Std.int(go.width * PlayState.daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('countdowns/$assetModifier/introGo'), 0.6);

					Conductor.songPosition = -(Conductor.crochet * 1);
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
