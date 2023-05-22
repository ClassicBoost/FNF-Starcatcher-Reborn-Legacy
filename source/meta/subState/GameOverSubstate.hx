package meta.subState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.Boyfriend;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.state.*;
import meta.state.menus.*;

class GameOverSubstate extends MusicBeatSubState
{
	//
	var bf:Boyfriend;
	var camFollow:FlxObject;

	public static var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daBoyfriendType = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (daBoyfriendType)
		{
			case 'bf-og':
				daBf = 'bf-ded-og';
			case 'bf-pixel':
				stageSuffix = '-pixel';
			default:
				daBf = 'bf-dead';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);
		if (daBf != 'bf-ded-og')
		bf.screenCenter();
		add(bf);

		PlayState.boyfriend.destroy();

		if (daBf == 'bf-ded-og')
		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 40, 1, 1);
		
		add(camFollow);

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deaths = 0;
			PlayState.daAdmin = 'ryan';

			PlayState.campaignScore = 0;
			PlayState.highestCombo = 0;
			PlayState.totalCombo = 0;
			PlayState.totalMisses = 0;
			PlayState.totalSongs = 0;
			PlayState.campaignAccuracy = 0;
			PlayState.inChart = false;

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

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

		// if (FlxG.sound.music.playing)
		//	Conductor.songPosition = FlxG.sound.music.time;
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					Main.switchState(this, new PlayState());
				});
			});
			//
		}
	}
}
