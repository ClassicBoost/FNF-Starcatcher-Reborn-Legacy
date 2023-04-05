package freeplay;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class FreeplayPREState extends MusicBeatState
{
	var options:Array<String> = ['Main','Extras','IYKYK','Classic','Mods'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var menuText:FlxText;

	private var main:FlxSprite;
	private var extras:FlxSprite;
	private var oglol:FlxSprite;
	private var iykykig:FlxSprite;
	private var damods:FlxSprite;

	var num:Int = 0;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Freeplay State", null);
		#end

		curSelected = 0;

		PlayState.classicMode = false;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/shared/sky-night'));
	//	bg.color = 0xFFB428FF;
		bg.updateHitbox();
		bg.screenCenter();
		bg.setGraphicSize(Std.int(bg.width * 1.35));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		main = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/main'));
		main.updateHitbox();
		main.screenCenter();
		main.antialiasing = ClientPrefs.globalAntialiasing;
		add(main);

		extras = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/extras'));
		extras.updateHitbox();
		extras.screenCenter();
		extras.antialiasing = ClientPrefs.globalAntialiasing;
		add(extras);

		oglol = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/classic'));
		oglol.updateHitbox();
		oglol.screenCenter();
		oglol.antialiasing = ClientPrefs.globalAntialiasing;
		add(oglol);

		iykykig = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/iykyk'));
		iykykig.updateHitbox();
		iykykig.screenCenter();
		iykykig.antialiasing = ClientPrefs.globalAntialiasing;
		add(iykykig);

		damods = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/mods'));
		damods.updateHitbox();
		damods.screenCenter();
		damods.antialiasing = ClientPrefs.globalAntialiasing;
		add(damods);

		menuText = new FlxText(12, FlxG.height - 100, 0, "", 12);
		menuText.scrollFactor.set();
		menuText.borderSize = 1.5;
		menuText.screenCenter(X);
		menuText.visible = false;
		menuText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(menuText);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			optionText.visible = false;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '', true);
		add(selectorRight);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_LEFT_P) {
			changeSelection(-1);
		}
		if (controls.UI_RIGHT_P) {
			changeSelection(1);
		}

		if (FlxG.keys.pressed.ALT) {
		//	changeSelection(-1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		menuText.screenCenter(X);

		menuText.screenCenter(X);

		var daSelected:String = options[curSelected];
		if (controls.ACCEPT) {
			switch (daSelected) {
				case 'Main':
					MusicBeatState.switchState(new freeplay.FreeplayState());
				case 'Classic':
					MusicBeatState.switchState(new freeplay.FreeplayClassicState());
				case 'Mods':
					MusicBeatState.switchState(new freeplay.NormalFreeplayState());
				case '???':
					FlxG.sound.play(Paths.sound('cancelMenu'));
					
			}
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		main.visible = false;
		extras.visible = false;
		iykykig.visible = false;
		oglol.visible = false;
		damods.visible = false;
		if (curSelected == 0) {
			main.visible = true;
		}
		if (curSelected == 1) {
			extras.visible = true;
		}
		if (curSelected == 2) {
			iykykig.visible = true;
		}
		if (curSelected == 3) {
			oglol.visible = true;
		}
		if (curSelected == 4) {
			damods.visible = true;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			item.color = 0xFFFFFFFF;
			if (item.targetY == 0) {
				item.alpha = 0;
				item.color = 0xFFFFEF68;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}