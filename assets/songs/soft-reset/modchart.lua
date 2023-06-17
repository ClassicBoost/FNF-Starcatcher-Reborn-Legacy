function onCreate()
	makeLuaSprite('black','fuckface',0,0)
	setProperty('black.scale.x', getProperty('black.scale.x') + 4);
	setProperty('black.scale.y', getProperty('black.scale.y') + 4);
	setScrollFactor('black', 0, 0);
	addLuaSprite('black',true)

	makeLuaSprite('black2','fuckface',0,0)
	setProperty('black2.scale.x', getProperty('black2.scale.x') + 4);
	setProperty('black2.scale.y', getProperty('black2.scale.y') + 4);
	setScrollFactor('black2', 0, 0);
	setObjectCamera('black2','hud')
	setProperty('black2.alpha',0.7)
	addLuaSprite('black2',true)

	makeLuaSprite('lol','thefunnyeffect',0,0)
	setProperty('lol.scale.x', getProperty('lol.scale.x') + 1);
	setProperty('lol.scale.y', getProperty('lol.scale.y') + 1);
	setScrollFactor('lol', 0, 0);
	setObjectCamera('lol','other')
	addLuaSprite('lol',true)

	setProperty('healthBar.alpha',0)
	setProperty('healthBarBG.alpha',0)
	setProperty('iconP1.alpha',0)
	setProperty('iconP2.alpha',0)
end
function onSongStart()
	setProperty('healthBar.alpha',0)
	setProperty('healthBarBG.alpha',0)
	setProperty('iconP1.alpha',0)
	setProperty('iconP2.alpha',0)
end
function onBeatHit()
	if curBeat == 64 then
		doTweenAlpha('fuck','black', 0.5, 2, 'linear')
	end
	if curBeat == 128 then
		doTweenAlpha('fuck','black', 1, 0.01, 'linear')
	end
	if curBeat == 134 then
		setProperty('black.alpha',0.5)
		setProperty('lol.alpha',0.5)
		setProperty('black2.alpha',0.5)
		cameraFlash('other','FFFFFF',1,true)
		setProperty('healthBar.alpha',1)
		setProperty('healthBarBG.alpha',1)
		setProperty('iconP1.alpha',1)
		setProperty('iconP2.alpha',1)
	end
	if curBeat >= 134 and curBeat < 582 then
		if getProperty('health') > 0.4 then
		setProperty('health',getProperty('health')-0.04)
		end
	end
end
function onUpdatePost()
	if curBeat <= 50 then
		setProperty('healthBar.alpha',0)
		setProperty('healthBarBG.alpha',0)
		setProperty('iconP1.alpha',0)
		setProperty('iconP2.alpha',0)
	end
end