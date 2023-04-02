colorchange = '71104B'
daTween = 'backIn'
function onCreate()
	makeLuaSprite('sky','backgrounds/shared/space',0,-300)	
	setScrollFactor('sky', 0, 0);
	setProperty('sky.scale.x', getProperty('sky.scale.x') + 1.5);
	setProperty('sky.scale.y', getProperty('sky.scale.y') + 1.5);
	setProperty('sky.antialiasing',false)
	addLuaSprite('sky',false)

	makeLuaSprite('sky2','backgrounds/shared/sky-night',200,-100)	
	setScrollFactor('sky2', 0, 0);
	setProperty('sky2.scale.x', getProperty('sky2.scale.x') + 1.4);
	setProperty('sky2.scale.y', getProperty('sky2.scale.y') + 1.4);
	addLuaSprite('sky2',false)

	makeLuaSprite('buildings','backgrounds/city/city',-750,-200)
	setScrollFactor('buildings', 0.1, 0.1);
	setProperty('buildingsship.scale.x', getProperty('buildings.scale.x') + 1.5);
	setProperty('buildings.scale.y', getProperty('buildings.scale.y') + 1.5);
	addLuaSprite('buildings',false)
	
	makeLuaSprite('ship','backgrounds/city/battlebus',1500,1545)	
	setProperty('ship.scale.x', getProperty('ship.scale.x') + 0.9);
	setProperty('ship.scale.y', getProperty('ship.scale.y') + 0.9);
	addLuaSprite('ship',false)

	makeLuaSprite('wind','backgrounds/city/wind',1000,-1100)	
	setProperty('wind.scale.x', getProperty('wind.scale.x') + 2);
	setProperty('wind.scale.y', getProperty('wind.scale.y') + 2);
	setObjectCamera('wind','other')
	addLuaSprite('wind',false)

	makeLuaSprite('wind2','backgrounds/city/wind',1000,-650)	
	setProperty('wind2.scale.x', getProperty('wind2.scale.x') + 2);
	setProperty('wind2.scale.y', getProperty('wind2.scale.y') + 2);
	addLuaSprite('wind2',false)
end
function onStepHit()
	if songName == 'High' then
		if curStep == 408 then
			doTweenX('windx','wind',1500,1.5,daTween)
			doTweenY('windy','wind',1900,1.5,daTween)
			doTweenX('wind2x','wind2',1500,1.5,daTween)
			doTweenY('wind2y','wind2',1900,1.5,daTween)
			doTweenX('buildingsx','buildings',-300,1.5,daTween)
			doTweenY('buildingsy','buildings',900,1.5,daTween)
		end
		if curStep == 416 then
			doTweenAlpha('nosky','sky2',0,0.75,'linear')
		end
		if curStep >= 416 then
			if getProperty('health') > 0.1 then
			setProperty('health',getProperty('health')-0.01)
			end
		end
	end
end
function onUpdate()
	if songName == 'High' then
		if curStep >= 416 then
		songPos = getSongPosition()
		currentBeat = (songPos/1000)*(bpm/60)
		setProperty("camHUD.angle",math.sin(currentBeat*math.pi/4)*4)
		setProperty("camGame.angle",math.sin(currentBeat*math.pi/8)*2)
		end
	end
end