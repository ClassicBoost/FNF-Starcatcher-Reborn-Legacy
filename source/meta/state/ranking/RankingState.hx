package meta.state.ranking;

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
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import gameObjects.*;
import gameObjects.userInterface.*;
import gameObjects.userInterface.notes.*;
import gameObjects.userInterface.notes.Strumline.UIStaticArrow;
import meta.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Song.SwagSong;
import flixel.addons.display.FlxBackdrop;
import meta.state.charting.*;
import meta.state.menus.*;
import meta.subState.*;
import flixel.text.FlxText;
import openfl.display.GraphicsShader;
import openfl.events.KeyboardEvent;
import openfl.filters.ShaderFilter;
import openfl.media.Sound;
import openfl.utils.Assets;
import sys.io.File;

using StringTools;

class RankingState extends MusicBeatState
{
	var fuckingRank:FlxSprite;
	var fuckingRankThing:FlxSprite;
	var theperson:FlxSprite;
	public var player:String = 'ryan';
	var disableControls = true;
	var bgcolor:FlxSprite;
	var coolText:FlxText;
	private var colorShit:FlxColor;
	var postscreen:FlxSprite;

	var rankBoard:FlxGroup;
	// rank board
	var boardBG:FlxSprite;
	var board:FlxSprite;
	var COMBO:FlxSprite;
	var textCombo:FlxText;
	var ROUNDTWO:FlxSprite;
	var ROUNDTWOCOMPLETE:FlxSprite;
	var TOTALSCORE:FlxSprite;
	var textScore:FlxText;
	var TOTALACCURACY:FlxSprite;
	var textAccuracy:FlxText;
	var TOTALCOMBOBREAKS:FlxSprite;
	var textMisses:FlxText;
	var pixelRanks:FlxSprite;

	var isPRank:Bool = true;

	var bg:FlxSprite; // because the color changes for P rank
	var bg1:FlxBackdrop;
	var bg2:FlxBackdrop;

	var shortTimer:Int = 5;

	override function create()
	{
		switch (PlayState.fuckingPlayer) {
			case 'connor','connor-old':
				player = 'connor';
				colorShit = 0xFF6D99FF;
			case 'poptop':
				player = 'blank';
				colorShit = 0xFFFFFFFF;
			default:
				player = 'ryan';
				colorShit = 0xFFFF8E5E;
		}

		disableControls = true;
		FlxG.sound.playMusic(Paths.music('no'), 0);

		PlayState.detailsSub = "";

		if (PlayState.forceRank != 0 && !Init.trueSettings.get('Debug Info'))
			PlayState.fuckingRankText = 'nothing';

		bg = new FlxSprite().loadGraphic(Paths.image('characters/rankings/gray'));
	//	bg.color = 0xFF7B7B7B;
		add(bg);

		bg1 = new FlxBackdrop(Paths.image('characters/rankings/base/bg/nothing'), 0, 0);
		bg1.alpha = 0;
		add(bg1);

		bg2 = new FlxBackdrop(Paths.image('characters/rankings/base/bg/${PlayState.fuckingRankText}'), 0, 0);
		bg2.alpha = 0;
		add(bg2);

		fuckingRank = new FlxSprite(Paths.image('characters/rankings/base/${PlayState.fuckingRankText}'));
		fuckingRank.antialiasing = true;
		fuckingRank.y -= 800;
		add(fuckingRank);

		postscreen = new FlxSprite(Paths.image('characters/rankings/characters/$player/${PlayState.fuckingRankText}-post'));
		postscreen.antialiasing = true;
		postscreen.screenCenter();
		postscreen.visible = false;
		add(postscreen);

		fuckingRankThing = new FlxSprite(Paths.image('characters/rankings/characters/$player/${PlayState.fuckingRankText}-text'));
		fuckingRankThing.antialiasing = false;
		fuckingRankThing.y -= 800;

		theperson = new FlxSprite(Paths.image('characters/rankings/characters/$player/${PlayState.fuckingRankText}'));
		theperson.antialiasing = true;
		if (PlayState.fuckingRankText != 'p')
		theperson.x -= 1000;
		else theperson.alpha = 0;
		if (player != 'blank') {
		add(theperson);
		} else {
			fuckingRank.x = -300;
			fuckingRankThing.x = -300;
		}

		add(fuckingRankThing);

		bgcolor = new FlxSprite(0, 0).makeGraphic(3000, 3000, 0xFFFFFFFF);
		bgcolor.visible = false;
		bgcolor.alpha = 0.6;
	//	if (PlayState.fuckingRankText != 'p')
	//	add(bgcolor);
		if (PlayState.fuckingRankText == 'd')
				shortTimer = 1;

		createRankBoard();

		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxTween.tween(bg1, {alpha: 1}, 0.25, {ease: FlxEase.linear});
			});
		if (PlayState.forceRank == 0)
		Highscore.saveRank(PlayState.SONG.song, 0);

		if (PlayState.fuckingRankText == 'd') {
		FlxG.sound.play(Paths.sound('ranks/youfail-${player}'), 1);
		if (player != 'connor')	FlxG.sound.play(Paths.sound('ranks/boooo'), 0.6);
		}
		else
		FlxG.sound.play(Paths.sound('ranks/sugary-spire/${PlayState.fuckingRankText}'), 0.6);

		new FlxTimer().start(shortTimer, function(fuckfuck:FlxTimer)
		{
			FlxG.camera.flash(0xFFFFFFFF, 1, null, true);
			if (PlayState.fuckingRankText != 'p') {
			FlxTween.tween(bg2, {alpha: 1}, 0.25, {ease: FlxEase.linear});
			FlxTween.tween(theperson, {x: 0}, 0.2, {ease: FlxEase.cubeOut});
			FlxTween.tween(fuckingRank, {y: 0}, 0.2, {ease: FlxEase.linear});
			FlxTween.tween(fuckingRankThing, {y: 0}, 0.21, {ease: FlxEase.linear});

			switch (PlayState.fuckingRankText) {
				case 'd':
					bg2.color = 0xFF383838;
					bg.color = 0xFF383838;
				case 'c':
					bg2.color = 0xFF60FF8D;
					bg.color = 0xFF60FF8D;
				case 'b':
					bg2.color = 0xFF5998FF;
					bg.color = 0xFF5998FF;
				case 'a':
					bg2.color = 0xFFFF615B;
					bg.color = 0xFFFF615B;
				case 's','s+':
					bg2.color = 0xFFFFF4A3;
					bg.color = 0xFFFFF4A3;
				default:
					bg2.color = 0xFFFFFFFF;
					bg.color = 0xFFFFFFFF;
			}
			} else theperson.alpha = 1;
			runSecondTimer();
		});
	}
	function createRankBoard() {
		boardBG = new FlxSprite(Paths.image('characters/rankings/board/bg'));
		boardBG.x = 600;
		boardBG.y = 1000;
		add(boardBG);

		board = new FlxSprite(Paths.image('characters/rankings/board/lines'));
		board.color = colorShit;
		board.x = 600;
		board.y = 1000;
		add(board);

		COMBO = new FlxSprite(Paths.image('characters/rankings/board/text/combo'));
		COMBO.x = boardBG.x + 400;
		COMBO.y = boardBG.y + 100 + 1000;
		COMBO.color = colorShit;
		add(COMBO);

		textCombo = new FlxText(0,0,0, '');
		textCombo.setFormat(28, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textCombo.text = '${PlayState.totalCombo}';
		textCombo.x = boardBG.x + 400;
		textCombo.y = boardBG.y + 100 + 30 + 1000;
		textCombo.borderSize = 2;
		add(textCombo);

		ROUNDTWO = new FlxSprite(Paths.image('characters/rankings/board/text/roundtwo'));
		ROUNDTWO.x = boardBG.x + 80;
		ROUNDTWO.y = boardBG.y + 100 + 1000;
		ROUNDTWO.color = colorShit;
		add(ROUNDTWO);

		ROUNDTWOCOMPLETE = new FlxSprite(Paths.image('characters/rankings/board/text/roundtwoCOMPLETE'));
		ROUNDTWOCOMPLETE.x = boardBG.x + 100;
		ROUNDTWOCOMPLETE.y = boardBG.y + 135 + 1000;
		ROUNDTWOCOMPLETE.visible = false;
		if (PlayState.roundTwoCompleted) ROUNDTWOCOMPLETE.visible = true;
		ROUNDTWOCOMPLETE.color = colorShit;
		add(ROUNDTWOCOMPLETE);

		TOTALSCORE = new FlxSprite(Paths.image('characters/rankings/board/text/score'));
		TOTALSCORE.x = boardBG.x + 60;
		TOTALSCORE.y = boardBG.y + 200 + 1000;
		TOTALSCORE.color = colorShit;
		add(TOTALSCORE);

		textScore = new FlxText(0,0,0, '');
		textScore.setFormat(28, FlxColor.WHITE, LEFT,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textScore.text = '${PlayState.campaignScore}';
		if (PlayState.forceRank != 0) textScore.text = 'DEBUG USED';
		textScore.x = boardBG.x + 60;
		textScore.y = boardBG.y + 200 + 40 + 1000;
		textScore.borderSize = 2;
		add(textScore);

		TOTALACCURACY = new FlxSprite(Paths.image('characters/rankings/board/text/accuracy'));
		TOTALACCURACY.x = boardBG.x + 60;
		TOTALACCURACY.y = boardBG.y + 300 + 1000;
		TOTALACCURACY.color = colorShit;
		add(TOTALACCURACY);

		textAccuracy = new FlxText(0,0,0, '');
		textAccuracy.setFormat(28, FlxColor.WHITE, LEFT,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textAccuracy.text = '${PlayState.actualAccuracy}%';
		textAccuracy.x = boardBG.x + 60;
		textAccuracy.y = boardBG.y + 300 + 40 + 1000;
		textAccuracy.borderSize = 2;
		add(textAccuracy);

		TOTALCOMBOBREAKS = new FlxSprite(Paths.image('characters/rankings/board/text/combo breaks'));
		TOTALCOMBOBREAKS.x = boardBG.x + 60;
		TOTALCOMBOBREAKS.y = boardBG.y + 400 + 1000;
		TOTALCOMBOBREAKS.color = colorShit;
		add(TOTALCOMBOBREAKS);

		textMisses = new FlxText(0,0,0, '');
		textMisses.setFormat(28, FlxColor.WHITE, LEFT,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textMisses.text = '${PlayState.totalMisses}';
		textMisses.x = boardBG.x + 60;
		textMisses.y = boardBG.y + 300 + 40 + 1000;
		textMisses.borderSize = 2;
		add(textMisses);

		pixelRanks = new FlxSprite(Paths.image('characters/rankings/board/pixel ranks/${PlayState.fuckingRankText}'));
		pixelRanks.color = colorShit;
		pixelRanks.y = 1000;
		pixelRanks.x = 10;
		pixelRanks.scale.set(0.8, 0.8);
		add(pixelRanks);

		coolText = new FlxText(0,0,0, '');
		coolText.setFormat(32, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		coolText.borderSize = 2;
	//	coolText.text = PlayState.fuckingRankText.toUpperCase();
	//	if (PlayState.forceRank == 0) coolText.text += '\nHighest Combo: ${PlayState.highestCombo}\nScore: ${PlayState.campaignScore}\nMisses: ${PlayState.totalMisses}\n\nENTER to Continue';
	//	else coolText.text += '\nUSED DEBUG TOOLS\nNO SCORE COUNTED\n\nENTER to Continue\n';
		coolText.text = 'Press ENTER to continue.\n';
		coolText.screenCenter();
		coolText.y += 300;
		coolText.alpha = 0;
		coolText.visible = false;
		coolText.scrollFactor.set();
		add(coolText);
	}
	function runSecondTimer() {
		if (PlayState.fuckingRankText != 'nothing') {
		if (shortTimer == 5)
		new FlxTimer().start(3.5, showResults);
		else
		new FlxTimer().start(7.5, showResults);
		} else {
			FlxTween.tween(theperson, {y: 900}, 500, {ease: FlxEase.linear,
				onComplete: function(twn:FlxTween)
				{
					FlxG.sound.play(Paths.sound('huh/YEA HAH'));
					new FlxTimer().start(0.6, function(fuckfuck:FlxTimer)
						{
							Sys.exit(0);
						});
				}});
		}
	}
	function showResults(time:FlxTimer = null) {
		FlxG.camera.flash(0xFFFFFFFF, 1, null, true);
		FlxG.sound.playMusic(Paths.music('sugarySpireResults'), 0.7);
		coolText.visible = true;
		bgcolor.visible = true;
		theperson.visible = false;
		disableControls = false;
		if (player != 'blank') postscreen.visible = true;

		bg1.alpha = 0;
		bg2.alpha = 0;

		FlxTween.tween(coolText, {alpha: 1}, 1, {ease: FlxEase.linear});
		FlxTween.tween(boardBG, {y: 70}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(board, {y: 70}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(COMBO, {y: 100 + 50}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(textCombo, {y: 100 + 30 + 50}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(ROUNDTWO, {y: 100 + 50}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(ROUNDTWOCOMPLETE, {y: 135 + 50}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(TOTALSCORE, {y: 70 + 200}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(textScore, {y: 70 + 200 + 40}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(TOTALACCURACY, {y: 70 + 300}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(textAccuracy, {y: 70 + 300 + 40}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(TOTALCOMBOBREAKS, {y: 70 + 400}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(textMisses, {y: 70 + 400 + 40}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(pixelRanks, {y: -30}, 1, {ease: FlxEase.cubeOut});
		if (PlayState.fuckingRankText == 'p') {
			bg.color = 0xFFBD6C8F;
			pixelRanks.color = 0xFFFF42AA;
			new FlxTimer().start(0.5, pRankSlide);
			isPRank = true;
		}

		if (player == 'blank') {
			new FlxTimer().start(0.5, pRankSlide);
			isPRank = false;
		} else {
			fuckingRank.visible = false;
			fuckingRankThing.visible = false;
		}
	}
	function pRankSlide(time:FlxTimer = null) {
		if (isPRank)
		FlxTween.tween(postscreen, {x: -350}, 1, {ease: FlxEase.cubeOut});
		else {
		FlxTween.tween(fuckingRank, {x: -600}, 1, {ease: FlxEase.cubeOut});
		FlxTween.tween(fuckingRankThing, {x: -600}, 1, {ease: FlxEase.cubeOut});
		}
	}
	override public function update(elapsed:Float) {
		if (!disableControls) {
			coolText.visible = true;
			bgcolor.visible = true;
			if (FlxG.keys.justPressed.ENTER) {
				PlayState.campaignScore = 0;
				PlayState.highestCombo = 0;
				PlayState.totalCombo = 0;
				PlayState.totalMisses = 0;
				PlayState.totalSongs = 0;
				PlayState.campaignAccuracy = 0;
				if (!MasterEditorMenu.inTerminal) {
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
				if (PlayState.isStoryMode) {
					Main.switchState(this, new StoryMenuState());
				} else {
					Main.switchState(this, new FreeplayState());
				}} else {
					FlxG.sound.playMusic(Paths.music('terminal'), 0.7);
					Main.switchState(this, new MasterEditorMenu());
				}
			}
		}

		var scrollSpeed:Float = 35;
		bg1.x -= scrollSpeed * elapsed;
		bg1.y -= scrollSpeed * elapsed;

		bg2.x -= scrollSpeed * elapsed;
		bg2.y -= scrollSpeed * elapsed;
	}
}
