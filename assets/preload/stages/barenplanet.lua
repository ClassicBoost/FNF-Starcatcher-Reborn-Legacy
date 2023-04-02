colorchange = '71104B'
function onCreate()
	makeLuaSprite('sky','backgrounds/shared/sky-night',200,-100)	
	setScrollFactor('sky', 0, 0);
	setProperty('sky.scale.x', getProperty('sky.scale.x') + 1);
	setProperty('sky.scale.y', getProperty('sky.scale.y') + 1);
	addLuaSprite('sky',false)
	
	makeLuaSprite('wellthen','backgrounds/baren',0,0)	
	setProperty('wellthen.scale.x', getProperty('wellthen.scale.x') + 1);
	setProperty('wellthen.scale.y', getProperty('wellthen.scale.y') + 1);
	addLuaSprite('wellthen',false)
	

end