colorchange = '71104B'
function onCreate()
	makeLuaSprite('sky','backgrounds/shared/space',500,-300)	
	setScrollFactor('sky', 0, 0);
	setProperty('sky.scale.x', getProperty('sky.scale.x') + 1);
	setProperty('sky.scale.y', getProperty('sky.scale.y') + 1);
	setProperty('sky.antialiasing',false)
	addLuaSprite('sky',false)
	makeLuaSprite('treef','backgrounds/forest/trees',400,-200)
	setScrollFactor('treef', 0.1, 0.1);
	setProperty('treefhouse.scale.x', getProperty('treef.scale.x') + 1.5);
	setProperty('treef.scale.y', getProperty('treef.scale.y') + 1.5);
	addLuaSprite('treef',false)
	
	makeLuaSprite('house','backgrounds/forest/house',0,245)	
	setProperty('house.scale.x', getProperty('house.scale.x') + 0.7);
	setProperty('house.scale.y', getProperty('house.scale.y') + 0.7);
	addLuaSprite('house',false)
end
function opponentNoteHit()
	triggerEvent('Screen Shake','0.3,0.0012','0.3,0.0012')
end