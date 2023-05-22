package meta.state.newMenu;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;
import meta.state.menus.*;

using StringTools;

class MenuState extends MusicBeatState
{
	var optionShit:Array<String> = ['play', 'options', 'credits'];

    private var selectedSomething:Bool = false;
    private var curSelected:Int = 0;

	var freakingText:FlxText;
	var asdfarattragf:String = '';
	var ogFreeplay:Bool = false;
    // menu options idiots
    var ryan:FlxSprite;
    var ian:FlxSprite;
    var creds:FlxSprite;
    override function create() {
        selectedSomething = false;
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image('menus/base/newmenu/bg'));
		bg.screenCenter();
		add(bg);

		FlxG.camera.flash(FlxColor.WHITE, 1);

        curSelected = 0;

		asdfarattragf = '';

		ryan = new FlxSprite();
		ryan.frames = Paths.getSparrowAtlas('menus/base/newmenu/placeholder');
		ryan.animation.addByPrefix('accept', 'accept', 24, true);
		ryan.animation.addByPrefix('idle', 'idle', 24, true);
		ryan.animation.addByPrefix('select', 'select', 24, true);
		ryan.animation.play('select', true);
		ryan.screenCenter();
		ryan.updateHitbox();
		add(ryan);

		ian = new FlxSprite();
		ian.frames = Paths.getSparrowAtlas('menus/base/newmenu/placeholder');
		ian.animation.addByPrefix('accept', 'accept', 24, true);
		ian.animation.addByPrefix('idle', 'idle', 24, true);
		ian.animation.addByPrefix('select', 'select', 24, true);
		ian.animation.play('idle', true);
		ian.screenCenter();
		ian.x -= 500;
		ian.updateHitbox();
		add(ian);

		creds = new FlxSprite();
		creds.frames = Paths.getSparrowAtlas('menus/base/newmenu/credits');
		creds.animation.addByPrefix('accept', 'accept', 24, true);
		creds.animation.addByPrefix('idle', 'idle', 24, true);
		creds.animation.addByPrefix('select', 'select', 24, true);
		creds.animation.play('idle', true);
		creds.screenCenter();
		creds.updateHitbox();
		add(creds);

		freakingText = new FlxText(0, 600, 0, 'PLAY');
		freakingText.setFormat('hobo.ttf', 40, FlxColor.WHITE);
		freakingText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		freakingText.screenCenter(X);
		add(freakingText);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 32, 0, "Starcatcher Reborn " + Main.starcatcherVER, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Axolotl Engine v1.1.0 (FE v" + Main.gameVersion + ")", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
    }

	override function update(elapsed:Float) {
        if (!selectedSomething) {
		if (controls.UI_LEFT_P)
		changeOption(true);
		if (controls.UI_RIGHT_P)
		changeOption(false);
        }

		if (FlxG.keys.justPressed.SHIFT)
			ogFreeplay = !ogFreeplay;

        if (controls.ACCEPT && !selectedSomething) {
			FlxG.sound.play(Paths.sound('confirmMenu'));

			switch (optionShit[Math.floor(curSelected)]) {
            case 'credits':
				CoolUtil.browserLoad('https://docs.google.com/document/d/1hET9MkQNVsjbl6Dozs_g6mzvNHGj_fW5a6IHJLr2sXY/edit?usp=sharing');
            case 'options':
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				Main.switchState(this, new OptionsMenuState());
            case 'play':
                selectedSomething = true;
                ryan.animation.play('accept', true);
				new FlxTimer().start(1, playThing);
            }
        }

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.sound.music.fadeOut(0.3);
			Main.switchState(this, new MasterEditorMenu());
		}

		if (curSelected == 0 && asdfarattragf != 'play')
		{
			ryan.animation.play('select', true);
			ian.animation.play('idle', true);
			creds.animation.play('idle', true);
			asdfarattragf = 'play';
		}
		if (curSelected == 1 && asdfarattragf != 'options')
		{
			ian.animation.play('select', true);
			ryan.animation.play('idle', true);
			creds.animation.play('idle', true);
			asdfarattragf = 'options';
		}
		if (curSelected == 2 && asdfarattragf != 'credits')
		{
			ian.animation.play('idle', true);
			ryan.animation.play('idle', true);
			creds.animation.play('select', true);
			asdfarattragf = 'credits';
		}

		freakingText.text = optionShit[Math.floor(curSelected)].toUpperCase() + (ogFreeplay == true ? ' (NORMAL)' : '');
		freakingText.screenCenter(X);
    }

	function playThing(time:FlxTimer = null) {
		if (ogFreeplay)
			Main.switchState(this, new FreeplayOGState());
		else
			Main.switchState(this, new FreeplayState());
    }

    function changeOption(left:Bool = false) {
		FlxG.sound.play(Paths.sound('scrollMenu'));

        if (left) curSelected++;
        else curSelected--;

		if (curSelected < 0)
			curSelected = optionShit.length - 1;
		else if (curSelected >= optionShit.length)
			curSelected = 0;
    }
}