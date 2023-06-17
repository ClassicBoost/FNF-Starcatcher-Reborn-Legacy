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
import flixel.tweens.FlxEase;
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

class OLDRankingState extends MusicBeatState
{
	var fuckingRank:FlxSprite;
	var theperson:FlxSprite;
	var fuckingRankThing:FlxSprite;
	var player:String = 'ryan';
	var disableControls = true;
	var bgcolor:FlxSprite;
	var coolText:FlxText;
	var shortTimer:Int = 4;
	// at the beginning of the playstate
	override function create()
	{
		switch (PlayState.fuckingPlayer) {
			case 'connor':
				player = 'connor';
			case 'connor-old':
				player = 'connor-old';
			case 'poptop':
				player = 'blank';
			default:
				player = 'ryan';
		}

		disableControls = true;
		FlxG.sound.playMusic(Paths.music('no'), 0);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/base/white'));
		add(bg);

		fuckingRank = new FlxSprite(Paths.image('characters/rankings/base/${PlayState.fuckingRankText}'));
		fuckingRank.antialiasing = true;
		fuckingRank.y += 800;
		add(fuckingRank);

		fuckingRankThing = new FlxSprite(Paths.image('characters/rankings/characters/$player/${PlayState.fuckingRankText}-text'));
		fuckingRankThing.antialiasing = false;
		fuckingRankThing.y += 800;

		theperson = new FlxSprite(Paths.image('characters/rankings/characters/$player/${PlayState.fuckingRankText}'));
		theperson.antialiasing = true;
		theperson.x -= 1000;
		if (player != 'none') {
		add(theperson);
		} else {
			fuckingRank.x = -300;
			fuckingRankThing.x = -300;
		}

		add(fuckingRankThing);

		bgcolor = new FlxSprite(0, 0).makeGraphic(3000, 3000, 0xFFFFFFFF);
		bgcolor.visible = false;
		bgcolor.alpha = 0.6;
		add(bgcolor);
		switch (PlayState.fuckingRankText) {
			case 'd':
				bgcolor.color = 0xFF383838;
			case 'c':
				bgcolor.color = 0xFF60FF8D;
			case 'b':
				bgcolor.color = 0xFF5998FF;
			case 'a':
				bgcolor.color = 0xFFFF615B;
			case 's','s+':
				bgcolor.color = 0xFFFFF4A3;
			default:
				bgcolor.color = 0xFFFFFFFF;
		}

		coolText = new FlxText(0,0,0, '');
		coolText.setFormat(32, FlxColor.WHITE, CENTER,FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		coolText.borderSize = 2;
		coolText.text = PlayState.fuckingRankText.toUpperCase();
		if (PlayState.forceRank == 0) coolText.text += '\nHighest Combo: ${PlayState.highestCombo}\nScore: ${PlayState.campaignScore}\nMisses: ${PlayState.totalMisses}\n\nENTER to Continue';
		else coolText.text += '\nUSED DEBUG TOOLS\nNO SCORE COUNTED\n\nENTER to Continue\n';
		coolText.screenCenter();
		coolText.visible = false;
		coolText.scrollFactor.set();
		add(coolText);

		if (PlayState.fuckingRankText == 'd') {
		FlxG.sound.play(Paths.sound('ranks/youfail-${player}'), 1);
		}

		Highscore.saveRank(PlayState.SONG.song, 0);

		FlxG.sound.play(Paths.sound('ranks/sugary-spire/old/${PlayState.fuckingRankText}'), 0.6);

		new FlxTimer().start(3.5, function(fuckfuck:FlxTimer)
		{
		//	FlxG.camera.flash(0xFFFFFFFF, 1, null, true);
			FlxTween.tween(theperson, {x: 0}, 1, {ease: FlxEase.cubeOut});
			FlxTween.tween(fuckingRank, {y: 0}, 0.7, {ease: FlxEase.linear});
			FlxTween.tween(fuckingRankThing, {y: 0}, 0.8, {ease: FlxEase.linear});
			runSecondTimer();
		});
	}
	function runSecondTimer() {
		new FlxTimer().start(9, endShit);
	}
	function endShit(time:FlxTimer = null) {
		PlayState.campaignScore = 0;
		PlayState.highestCombo = 0;
		PlayState.totalCombo = 0;
		PlayState.totalSongs = 0;
		PlayState.totalMisses = 0;
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
	override public function update(elapsed:Float) {
			if (FlxG.keys.justPressed.ENTER) {
				endShit();
			}
	}
}