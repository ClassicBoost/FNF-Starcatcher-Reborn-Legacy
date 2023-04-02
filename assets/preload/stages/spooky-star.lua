colorchange = '71104B'
function onCreate()
	makeLuaSprite('sky','backgrounds/shared/sky-night',500,-300)	
	setScrollFactor('sky', 0, 0);
	setProperty('sky.scale.x', getProperty('sky.scale.x') + 1);
	setProperty('sky.scale.y', getProperty('sky.scale.y') + 1);
	addLuaSprite('sky',false)

	makeLuaSprite('space','backgrounds/shared/space-lit',0,-300)
	setScrollFactor('space', 0, 0);
	addLuaSprite('space',false)

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
function onCreatePost()
	setProperty('space.visible',false)
end
function onStepHit()
	if curStep == 912 and songName == 'Mirage' then
		doTweenColor('bfColorTween', 'boyfriend', colorchange, 0.01);
		doTweenColor('dadColorTween', 'dad', colorchange, 0.01);
		doTweenColor('gfColorTween', 'gf', colorchange, 0.01);
		doTweenColor('treefColorTween', 'treef', colorchange, 0.01);
		doTweenColor('houseColorTween', 'house', colorchange, 0.01);
		setProperty('space.visible',true)
	end
end