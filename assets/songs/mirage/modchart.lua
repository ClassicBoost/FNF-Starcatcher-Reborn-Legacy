--All Arrows moving Left and Right
local yes = false
function onCreate()
	makeLuaSprite('black','fuckface',0,0)
	setProperty('black.scale.x', getProperty('black.scale.x') + 4);
	setProperty('black.scale.y', getProperty('black.scale.y') + 4);
	setScrollFactor('black', 0, 0);
	addLuaSprite('black',true)
end
function onUpdate(elapsed)
songPos = getSongPosition()
local currentBeat = (songPos/2000)*(curBpm/60)

if yes then
noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)


noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 - 60*math.sin((currentBeat+1*0.25)*math.pi), 0.5)

noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 40*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 40*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 40*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 40*math.sin((currentBeat+7*0.25)*math.pi), 0.5)

noteTweenY('defaultOpponentStrumY0', 0, defaultOpponentStrumY0 + 40*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
noteTweenY('defaultOpponentStrumY1', 1, defaultOpponentStrumY1 + 40*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
noteTweenY('defaultOpponentStrumY2', 2, defaultOpponentStrumY2 + 40*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
noteTweenY('defaultOpponentStrumY3', 3, defaultOpponentStrumY3 + 40*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
end
end
function onSongStart()
	doTweenAlpha('fuck','black', 0, 5, 'linear')
	setProperty('camHUD.visible',false)
end

function onStepHit()
	if curStep == 64 then
		setProperty('camHUD.visible',true)
	end
	if curStep == 896 then
		doTweenAlpha('fuck','black', 1, 0.5, 'linear')
	end
	if curStep == 928 then
	yes = true
	doTweenAlpha('fuck','black', 0, 2, 'linear')
	end
	if curStep == 1216 then
	yes = false
	noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0, 0.5)
	noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1, 0.5)
	noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2, 0.5)
	noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3, 0.5)
	noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0, 0.5)
	noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1, 0.5)
	noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2, 0.5)
	noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3, 0.5)
	end
end