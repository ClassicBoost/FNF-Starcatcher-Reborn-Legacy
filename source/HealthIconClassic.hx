package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIconClassic extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var initialWidth:Float = 0;
	public var initialHeight:Float = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/freeplay/' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/iykyk/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/main/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/extras/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/classic/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file, true, 150, 150);
			updateHitbox();

			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	public function getCharacter():String {
		return char;
	}
}