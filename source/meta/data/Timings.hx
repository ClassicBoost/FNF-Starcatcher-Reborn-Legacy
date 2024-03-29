package meta.data;

import gameObjects.userInterface.notes.*;
import meta.state.PlayState;

/**
	Here's a class that calculates timings and judgements for the songs and such
**/
class Timings
{
	//
	public static var accuracy:Float;
	public static var trueAccuracy:Float;
	public static var judgementRates:Array<Float>;

	// from left to right
	// max milliseconds, score from it and percentage
	public static var judgementsMap:Map<String, Array<Dynamic>> = [
		"sick" => [0, (Init.trueSettings.get("Harder Safeframes") ? 20 : Init.trueSettings.get("Back to the Basics") ? 45 : 55), 350, 100, (PlayState.useDefaultForever ? ' [MFC]' : ' | MFC')],
		"good" => [1, (Init.trueSettings.get("Harder Safeframes") ? 40 : Init.trueSettings.get("Back to the Basics") ? 90 : 90), 200, 75, (PlayState.useDefaultForever ? ' [GFC]' : ' | GFC')],
		"bad" => [2, (Init.trueSettings.get("Harder Safeframes") ? 80 : Init.trueSettings.get("Back to the Basics") ? 135 : 120), 75, 50, (PlayState.useDefaultForever ? ' [FC]' : ' | FC')],
		"shit" => [3, (Init.trueSettings.get("Harder Safeframes") ? 125 : Init.trueSettings.get("Back to the Basics") ? 157.5 : 150), 0, 25, (PlayState.useDefaultForever ? ' [FC-]' : ' | FC-')],
		"miss" => [4, 180, 0, -100],
	];

	public static var msThreshold:Float = 0;

	// set the score judgements for later use
	public static var scoreRating:Map<String, Int> = [
		"P" => 100,
		"S" => 95,
		"A" => 90,
		"B" => 85,
		"C" => 80,
		"D" => 75,
	//	"E" => 70,
	//	"F" => 65,
	];

	public static var ratingFinal:String = "N/A";
	public static var notesHit:Int = 0;
	public static var segmentsHit:Int = 0;
	public static var comboDisplay:String = '';

	public static var gottenJudgements:Map<String, Int> = [];
	public static var smallestRating:String;

	public static function callAccuracy()
	{
		// reset the accuracy to 0%
		accuracy = 0.001;
		trueAccuracy = 0;
		judgementRates = new Array<Float>();

		// reset ms threshold
		var biggestThreshold:Float = 0;
		for (i in judgementsMap.keys())
			if (judgementsMap.get(i)[1] > biggestThreshold)
				biggestThreshold = judgementsMap.get(i)[1];
		msThreshold = biggestThreshold;

		// set the gotten judgement amounts
		for (judgement in judgementsMap.keys())
			gottenJudgements.set(judgement, 0);
		smallestRating = 'sick';

		notesHit = 0;
		segmentsHit = 0;

		ratingFinal = "N/A";

		comboDisplay = '';
	}

	public static function updateAccuracy(judgement:Int, ?isSustain:Bool = false, ?segmentCount:Int = 1)
	{
		if (!isSustain)
		{
			notesHit++;
			accuracy += (Math.max(0, judgement));
		}
		else
		{
			accuracy += (Math.max(0, judgement) / segmentCount);
		}
		trueAccuracy = (accuracy / notesHit);

		updateFCDisplay();
		updateScoreRating();
	}

	public static function updateFCDisplay()
	{
		// update combo display
		comboDisplay = '';
		if (judgementsMap.get(smallestRating)[4] != null)
			comboDisplay = judgementsMap.get(smallestRating)[4];
		else
		{
			if (PlayState.misses < 10)
				comboDisplay = ' [SDCB]';
			if (PlayState.misses >= 65 && PlayState.misses < 500)
				comboDisplay = ' [Skill Issue]';
			if (PlayState.misses >= 500)
				comboDisplay = ' [wtf?]';
		}

		// this updates the most so uh
		PlayState.uiHUD.updateScoreText();
	}

	public static function getAccuracy()
	{
		return trueAccuracy;
	}

	public static function updateScoreRating()
	{
		var biggest:Int = 0;
		for (score in scoreRating.keys())
		{
			if ((scoreRating.get(score) <= trueAccuracy) && (scoreRating.get(score) >= biggest))
			{
				biggest = scoreRating.get(score);
				ratingFinal = score;
			}
		}
	}

	public static function returnScoreRating()
	{
		return ratingFinal;
	}
}
