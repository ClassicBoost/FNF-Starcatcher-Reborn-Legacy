import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement
		// in starbound all achivements are hidden, but what if all of them are hidden here? Does the game crash or do you just enter a blank page?
		["Just like in the game",		"Play on a Friday... Night.",						'friday_night_play',	 false],
		["She Calls Me Daddy Too",		"Beat Week 1 with no Misses.",						'week1_nomiss',			false],
		["No More Tricks",				"Beat Week 2 with no Misses.",						'week2_nomiss',			false],
		["Call Me The Hitman",			"Beat Week 3 with no Misses.",						'week3_nomiss',			true],// Visible once that week is finished
		["Lady Killer",					"Beat Week 4 with no Misses.",						'week4_nomiss',			true],// Visible once that week is finished
		["Missless Christmas",			"Beat Week 5 with no Misses.",						'week5_nomiss',			true],// Visible once that week is finished
		["Highscore!!",					"Beat Week 6 with no Misses.",						'week6_nomiss',			true],// Visible once that week is finished
		["God Effing Damn It!",			"Beat Week 7 with no Misses.",						'week7_nomiss',			true],// Visible once that week is finished
		["The boys, and a lady",		"Beat Week 8 with no Misses.",						'week8_nomiss',			true],// Visible once that week is finished
		["Enough!",						"Beat Week 1 on Fucked with no Misses.",			'week1f_nomiss',		true],// Visible once that week is finished
		["What a Funkin' Disaster!",	"Complete a Song with a D rank.",					'ur_bad',				false],
		["Perfectionist",				"Complete a Song with a S rank.",					'ur_good',				false],
		["True Perfectionist",			"Complete a Song with a P rank.",					'ur_toogood',			false],
		["Oversinging Much...?",		"Hold down a note for 10 seconds.",					'oversinging',			false],
		["Hyperactive",					"Finish a Song without going Idle.",				'hype',					false],
		["Just the Two of Us",			"Finish a Song pressing only two keys.",			'two_keys',				false],
		["Lore, not accurate",			"FC a song with Wiki accurate modifier enabled. The reason is that because from what I heard Avali isn't suppose to do rhythm game or some shit like I play starbound and I put that image in the files and I do read the wiki too much to know this even if I was just tl;dr anyway how's your day been going? Good? yeah same here, so what do you want to play? Minecraft? Okay I think at this point this is going off screen, yet I'm not gonna post the source code publically so if you are reading this then you're wasting your time reading this stupid ass message just for one joke over fucking chickens. Also if you are reading this because this popped up then you better take a screenshot to read all of this even if this proceeds to go off screen. Wait if you're playing as Connor then how would it make sense? Connor is a human not an avali oh well. Anyways I want to talk about today's sponsor Raid Shadow Legends, one of the biggest mobile role-playing games of 2019 and it's totally free! Currently almost 10 million users have joined Raid over the last six months, and it's one of the most impressive games in its class with detailed models, environments and smooth 60 frames per second animations! All the champions in the game can be customized with unique gear that changes your strategic buffs and abilities! The dungeon bosses have some ridiculous skills of their own and figuring out the perfect party and strategy to overtake them's a lot of fun! Currently with over 300,000 reviews, Raid has almost a perfect score on the Play Store! The community is growing fast and the highly anticipated new faction wars feature is now live, you might even find my squad out there in the arena! It's easier to start now than ever with rates program for new players you get a new daily login reward for the first 90 days that you play in the game! So what are you waiting for? Go to the video description, click on the special links and you'll get 50,000 silver and a free epic champion as part of the new player program to start your journey! Good luck and I'll see you there! If you get to this comment Classic is a bitch in gamebanana",	'wellthen',				false],
		["Ok then",						"Get 0% accuracy (if only there was a mode that allows that)",			'bruh',				true],
		["Debugger",					"Beat the \"Test\" Stage from the Chart Editor.",	'debugger',				 true]
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Achievement Unlock "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('achievementUnlock'), 0.7); // exactly, nothing. Because steam does not play a sound if you unlock a achievement
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}
		}
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			loadGraphic(Paths.image('achievements/' + tag));
		} else {
			loadGraphic(Paths.image('achievements/lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image('achievements/' + name));
		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();

		add(achievementBG);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}