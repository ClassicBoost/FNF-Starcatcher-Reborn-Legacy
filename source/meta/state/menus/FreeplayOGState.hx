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
import gameObjects.userInterface.HealthIcon;
import lime.utils.Assets;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import flixel.util.FlxTimer;
import meta.state.newMenu.*;
import openfl.media.Sound;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;

using StringTools;

class FreeplayOGState extends MusicBeatState
{
	//
	var songs:Array<SongMetadataOG> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curSongPlaying:Int = -1;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var ratingText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var songThread:Thread;
	var threadActive:Bool = true;
	var mutex:Mutex;
	var songToPlay:Sound = null;

	public static var bpms:Array<Float> = [];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	private var mainColor = FlxColor.WHITE;
	private var bg:FlxSprite;
	private var scoreBG:FlxSprite;

	private var showStats:Bool = false;

	private var existingSongs:Array<String> = [];
	private var existingDifficulties:Array<Array<String>> = [];

	var folderSongs:Array<String> = CoolUtil.returnAssetsLibrary('songs', 'assets');

	private var theSongStuff:FlxText;

	private var disablebop:Bool = false;
	private var disablethisthingy:Bool = false;
	private var disablescreenbop:Bool = false;
	private var lengthshit:Float = 0.6; // BPM 100

	override function create()
	{
		super.create();

		mutex = new Mutex();

		persistentUpdate = true;

		/**
			Wanna add songs? They're in the Main state now, you can just find the week array and add a song there to a specific week.
			Alternatively, you can make a folder in the Songs folder and put your songs there, however, this gives you less
			control over what you can display about the song (color, icon, etc) since it will be pregenerated for you instead.
		**/
		// load in all songs that exist in folder

		///*
	/*	for (i in 0...Main.gameWeeks.length)
		{
			addWeek(Main.gameWeeks[i][0], i, Main.gameWeeks[i][1], Main.gameWeeks[i][2], 160);
			for (j in cast(Main.gameWeeks[i][0], Array<Dynamic>))
				existingSongs.push(j.toLowerCase());
		}*/

		// */

		for (i in folderSongs)
		{
			if (!existingSongs.contains(i.toLowerCase()))
			{
				var icon:String = 'gf';
				var chartExists:Bool = FileSystem.exists(Paths.songJson(i, i));
				var songBPMthing:Float = 100.0;
				if (chartExists)
				{
					var castSong:SwagSong = Song.loadFromJson(i, i);
					icon = (castSong != null) ? castSong.player2 : 'gf';
					songBPMthing = castSong.bpm;
					addSong(CoolUtil.spaceToDash(castSong.song), 1, icon, FlxColor.WHITE, songBPMthing);
				}
			}
		}

		// LOAD MUSIC
		// ForeverTools.resetMenuMusic();

		#if DISCORD_RPC
		Discord.changePresence('FREEPLAY MENU', 'Main Menu');
		#end

		// LOAD CHARACTERS
		bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		disablebop = false;

		lengthshit = 0.6;

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - scoreText.width, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.alignment = CENTER;
		diffText.font = scoreText.font;
		diffText.x = scoreBG.getGraphicMidpoint().x;
		add(diffText);

		theSongStuff = new FlxText(200, 300, 0, 'hi there');
		theSongStuff.setFormat(25, FlxColor.WHITE);
		theSongStuff.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		theSongStuff.visible = showStats;
		add(theSongStuff);

		ratingText = new FlxText(FlxG.width * 0.7, scoreText.y + 70, 0, "", 32);
		ratingText.setFormat(Paths.font("vcr.ttf"), 150, FlxColor.WHITE, RIGHT);
		ratingText.x += 250;
		add(ratingText);

		add(scoreText);

		changeSelection();
		changeDiff();

		trace(bpms);

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();
		selector.size = 40;
		selector.text = ">";
		// add(selector);
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor, bpm:Float)
	{
		///*
		var coolDifficultyArray = [];
		for (i in CoolUtil.difficultyArray)
			if (FileSystem.exists(Paths.songJson(songName, songName + '-' + i))
				|| (FileSystem.exists(Paths.songJson(songName, songName)) && i == "NORMAL"))
				coolDifficultyArray.push(i);

		if (coolDifficultyArray.length > 0)
		{ //*/
			songs.push(new SongMetadataOG(songName, weekNum, songCharacter, songColor, bpm));
			existingDifficulties.push(coolDifficultyArray);
		}

		bpms.push(Song.loadFromJson(songName, songName.toLowerCase()).bpm);
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songColor:Array<FlxColor>, bpm:Float)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];
		if (songColor == null)
			songColor = [FlxColor.WHITE];

		var num:Array<Int> = [0, 0];
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num[0]], songColor[num[1]], bpm);

			if (songCharacters.length != 1)
				num[0]++;
			if (songColor.length != 1)
				num[1]++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxTween.color(bg, 0.35, bg.color, mainColor);

		var lerpVal = Main.framerateAdjust(0.1);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, lerpVal));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		else if (downP)
			changeSelection(1);

		if (FlxG.keys.justPressed.SEVEN && Init.trueSettings.get('Debug Info'))
			showStats = !showStats;

		theSongStuff.visible = showStats;

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if(zoomTween != null) zoomTween.cancel();
			threadActive = false;
			if (Main.useNewMenu)
			Main.switchState(this, new MenuState());
			else
			Main.switchState(this, new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(),
				CoolUtil.difficultyArray.indexOf(existingDifficulties[curSelected][curDifficulty]));

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			threadActive = false;

			Main.switchState(this, new PlayState());
		} else { 
		//	Conductor.changeBPM(songs[curSelected].bpm);
			
		}

		// Adhere the position of all the things (I'm sorry it was just so ugly before I had to fix it Shubs)
		scoreText.text = "PERSONAL BEST:" + lerpScore;
		scoreText.x = FlxG.width - scoreText.width - 5;
		scoreBG.width = scoreText.width + 8;
		scoreBG.x = FlxG.width - scoreBG.width;
		diffText.x = scoreBG.x + (scoreBG.width / 2) - (diffText.width / 2);

		theSongStuff.text = 'curBeat: $curBeat\ncurStep: $curStep\nBPM: ${songs[curSelected].bpm}\n';

		if (!disablebop && !disablethisthingy) {
			disablethisthingy = true;
			new FlxTimer().start((lengthshit * 2), zoomCam);
		}

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));

		mutex.acquire();
		if (songToPlay != null)
		{
			FlxG.sound.playMusic(songToPlay);

			if (FlxG.sound.music.fadeTween != null)
				FlxG.sound.music.fadeTween.cancel();

			FlxG.sound.music.volume = 0.0;
			FlxG.sound.music.fadeIn(1.0, 0.0, 1.0);

			songToPlay = null;
		}
		mutex.release();
	}

	var lastDifficulty:String;

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		if (lastDifficulty != null && change != 0)
			while (existingDifficulties[curSelected][curDifficulty] == lastDifficulty)
				curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = existingDifficulties[curSelected].length - 1;
		if (curDifficulty > existingDifficulties[curSelected].length - 1)
			curDifficulty = 0;

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		diffText.text = '< ' + existingDifficulties[curSelected][curDifficulty] + ' >';
		lastDifficulty = existingDifficulties[curSelected][curDifficulty];
	}
	var lastRating:Int = 0;
	function changeSelection(change:Int = 0, muteAudio:Bool = false)
	{
		if (!muteAudio)
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		Conductor.changeBPM(bpms[curSelected]);

		// selector.y = (70 * curSelected) + 30;

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		ratingText.color = 0xFFFFFFFF;
		switch (Highscore.getRating(songs[curSelected].songName)) {
			case 1:
				ratingText.text = 'D';
			case 2:
				ratingText.color = 0xFF00D315;
				ratingText.text = 'C';
			case 3:
				ratingText.color = 0xFF66BFFF;
				ratingText.text = 'B';
			case 4:
				ratingText.color = 0xFFFF4949;
				ratingText.text = 'A';
			case 5:
				ratingText.color = 0xFFFFFF9B;
				ratingText.text = 'S';
			case 6:
				ratingText.color = 0xFFFFFF9B;
				ratingText.text = 'S+';
			case 7:
				ratingText.color = 0xFFD170FF;
				ratingText.text = 'P';
			default:
				ratingText.text = '?';
		}

		if (Highscore.getRating(songs[curSelected].songName) != lastRating) {
			FlxTween.cancelTweensOf(ratingText);
			ratingText.x = (FlxG.width * 0.7 + 600);
			FlxTween.tween(ratingText, {x: (FlxG.width * 0.7 + 250)}, 1, {ease: FlxEase.bounceOut});
			lastRating = Highscore.getRating(songs[curSelected].songName);
		}

		// set up color stuffs
		mainColor = songs[curSelected].songColor;

		// song switching stuffs

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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
		//

		trace("curSelected: " + curSelected);

	//	updateSongBOP();
		changeDiff();
		changeSongPlaying();
	}
	var zoomTween:FlxTween;
	override function beatHit() {
		super.beatHit();
		if (curBeat % 2 == 0) {

		}
		Conductor.changeBPM(bpms[curSelected]);
	//	FlxG.sound.play(Paths.sound('hitsound'), 1);
	}

	function updateSongBOP() {
		lengthshit = 0;
		if(zoomTween != null) zoomTween.cancel();
		disablethisthingy = false;
		switch (songs[curSelected].songName.toLowerCase()) {
			case 'ataefull':
				lengthshit = 0.308;
			case 'mirage':
				lengthshit = 0.444;
			case 'test':
				lengthshit = 0.4;
			default:
				disablethisthingy = true;
		}
	}

	public function zoomCam(time:FlxTimer = null) {
		if (!disablebop) {
		disablebop = true;
		if (disablethisthingy) {
	//	FlxG.camera.zoom = 1.05; // disable this for now
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

	function changeSongPlaying()
	{
		if (songThread == null)
		{
			songThread = Thread.create(function()
			{
				while (true)
				{
					if (!threadActive)
					{
						trace("Killing thread");
						return;
					}

					var index:Null<Int> = Thread.readMessage(false);
					if (index != null)
					{
						if (index == curSelected && index != curSongPlaying)
						{
							trace("Loading index " + index);

							var inst:Sound = Paths.inst(songs[curSelected].songName);

							if (index == curSelected && threadActive)
							{
								mutex.acquire();
								songToPlay = inst;
								mutex.release();

								curSongPlaying = curSelected;
							}
							else
								trace("Nevermind, skipping " + index);
						}
						else
							trace("Skipping " + index);
					}
				}
			});
		}

		songThread.sendMessage(curSelected);
	}

	var playingSongs:Array<FlxSound> = [];
}

class SongMetadataOG
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songColor:FlxColor = FlxColor.WHITE;
	public var bpm:Float = 100.0;

	public function new(song:String, week:Int, songCharacter:String, songColor:FlxColor, bpm:Float)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songColor = songColor;
		this.bpm = bpm;
	}
}
