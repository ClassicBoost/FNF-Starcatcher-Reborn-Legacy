-- MOD SETTINGS
local lateDamage = false --Should hitting notes late/early hurt you?
local newIconBop = true --Use the new icon bop?
local showJudgements = false --Should it show the judgement counter?
local oldInput = false --heheheha (NOT RECCOMENDED)



--LINE
daRank = ''
bopZoom = 1
thejudge = '?'
getSick = 0
getGood = 0
getBad = 0
getShit = 0
missrow = 0

function onCreate()
    makeLuaText('watermark', '', 0, 5, 0);
    setTextSize('watermark', 16);
	addLuaText('watermark');

    makeLuaText('judge','SICK x000', 150, 565, 150);
    setTextSize('judge', 50);
	addLuaText('judge');

    makeLuaText('daRankShit', '?', 2050, 5, 630);
    setTextSize('daRankShit', 70);
	addLuaText('daRankShit');
    triggerEvent('Add Camera Zoom',0,3)

    getSick = 0
    getGood = 0
    getBad = 0
    getShit = 0
end
function onSongStart()
    setProperty('camZooming',true)
end
function onBeatHit()
    if newIconBop == true then
    if getProperty('curBeat') % 1 == 0 then
        setProperty('timeTxt.angle',1*-5)
        doTweenAngle('ho','timeTxt', 0, 0.5, 'sineInOut')
    if getProperty('health') > 1.6 then
        setProperty('iconP1.angle',1*10)
        setProperty('iconP2.angle',1*0)
        doTweenAngle('re', 'iconP1', 0, 0.5, 'sineInOut')
    elseif getProperty('health') < 0.4 then
        setProperty('iconP1.angle',1*0)
        setProperty('iconP2.angle',1*10)
        doTweenAngle('ree', 'iconP2', 0, 0.5, 'sineInOut')
    else
        setProperty('iconP1.angle',1*10)
        setProperty('iconP2.angle',1*-10)
        doTweenAngle('re', 'iconP1', 0, 0.5, 'sineInOut')
        doTweenAngle('ree', 'iconP2', 0, 0.5, 'sineInOut')
    end
end
end

    if getProperty('curBeat') % 2 == 0 then
        setProperty('timeTxt.angle',1*5)
        doTweenAngle('ho','timeTxt', 0, 0.5, 'linear')
    if getProperty('health') > 1.6 then
        setProperty('iconP1.angle',1*-15)
        setProperty('iconP2.angle',1*0)
        doTweenAngle('re', 'iconP1', 0, 0.5, 'linear')
    elseif getProperty('health') < 0.4 then
        setProperty('iconP1.angle',1*0)
        setProperty('iconP2.angle',1*-15)
        doTweenAngle('ree', 'iconP2', 0, 0.5, 'linear')
    else
        setProperty('iconP1.angle',1*-15)
        setProperty('iconP2.angle',1*15)
        doTweenAngle('re', 'iconP1', 0, 0.5, 'linear')
        doTweenAngle('ree', 'iconP2', 0, 0.5, 'linear')
    end
end


    bopZoom = 1.0
    if ratingName == 'Good' then
        bopZoom = 1.1
    elseif ratingName == 'Great' then
        bopZoom = 1.2
    elseif ratingName == 'Perfect!!' or ratingName == 'Sick!' then
        bopZoom = 1.3
    end

    setProperty('daRankShit.scale.x',bopZoom)
	setProperty('daRankShit.scale.y',bopZoom)
	doTweenX('stuffx','daRankShit.scale', 1, 0.25, 'cubeOut')
	doTweenY('stuffy','daRankShit.scale', 1, 0.25, 'cubeOut')
end
function onUpdate()
    if oldInput == true then
    if inputLag then
        setProperty('boyfriend.stunned', true);
    else
        setProperty('boyfriend.stunned', false);
        runTimer('Lag', .2)
    end
end
end
function onUpdatePost()
    if getProperty('iconP1.angle') > 0 then
        setProperty('iconP1.angle',getProperty('iconP1.angle')-1)
    end
    if getProperty('iconP1.angle') < 0 then
        setProperty('iconP1.angle',getProperty('iconP1.angle')+1)
    end

    if getProperty('iconP2.angle') > 0 then
        setProperty('iconP2.angle',getProperty('iconP2.angle')-1)
    end
    if getProperty('iconP2.angle') < 0 then
        setProperty('iconP2.angle',getProperty('iconP2.angle')+1)
    end

    setTextString('judge',thejudge..'\nx'..(getProperty('combo') + missrow))

    setProperty('timeBar.visible',false)
    setProperty('timeBarBG.visible',false)

    setObjectCamera('countdownReady', 'other')
    setObjectCamera('countdownSet', 'other')
    setObjectCamera('countdownGo', 'other')

    if getProperty('songScore') == 0 then
		daRank = '?'
        setTextColor('daRankShit','FFFFFF')
    else
    setTextString('daRankShit',daRank)
    if ratingName == 'D' or ratingName == 'E' or ratingName == 'F' then
        daRank = 'D'
        setTextColor('daRankShit','FFFFFF')
    elseif ratingName == 'C' then
        daRank = 'C'
        setTextColor('daRankShit','66FF9E')
    elseif ratingName == 'B' then
        daRank = 'B'
        setTextColor('daRankShit','21BCFF')
    elseif ratingName == 'A' then
        daRank = 'A'
        setTextColor('daRankShit','FF494C')
    elseif ratingName == 'S' then
        daRank = 'S'
        setTextColor('daRankShit','FFF189')
    elseif ratingName == 'S+' then
        daRank = 'P'
        setTextColor('daRankShit','C55BFF')
    end
end
end
function goodNoteHit(id, direction, noteType, isSustainNote)
    math.randomseed(os.time());
    missSound = string.format('missnote%i', math.random(1, 3));

    if getProperty('sicks') ~= getSick then
    thejudge = 'SICK!'
    elseif getProperty('goods') ~= getGood then
    thejudge = 'OK'
    elseif getProperty('bads') ~= getBad then
    thejudge = 'EHH'
    if lateDamage == true then
    setProperty('health',getProperty('health')-0.05)
    end
    elseif getProperty('shits') ~= getShit then
    thejudge = 'CRAP'
    if lateDamage == true then
    setProperty('health',getProperty('health')-0.15)
    setProperty('combo',0)
    playSound(missSound, 2, 'missnoteSND');
    setProperty('songMisses',getProperty('songMisses')+1)
    end
    end

    missrow = 0

    getSick = getProperty('sicks')
    getGood = getProperty('goods')
    getBad = getProperty('bads')
    getShit = getProperty('shits')

    if oldInput == true then
        inputLag = true
        if isSustainNote == false then
        runTimer('Lag', .1)
        else
        inputLag = false
        end
    end
end
--why can't there just be only one note miss?
function noteMiss()
    setProperty('songScore',getProperty('songScore')-15)
    if songName ~= 'WTF' then
    playSound('avalihurt')
    else
    playSound('poptop_notice1')
    end
    setProperty('health',getProperty('health')-0.06)
    thejudge = 'MISS'
    missrow = missrow - 1
end
function noteMissPress()
    setProperty('songScore',getProperty('songScore')-15)
    if songName ~= 'WTF' then
    playSound('avalihurt')
    else
    playSound('poptop_notice1')
    end
    setProperty('health',getProperty('health')-0.06)
    thejudge = 'MISS'
    missrow = missrow - 1
end
function onUpdateScore(notemiss)
    if notemiss == true then
    setTextColor('judge','FF322B')
    else
    if getProperty('goods') == 0 and getProperty('bads') == 0 and getProperty('shits') == 0 then
    setTextColor('judge','FFEFA3')
    else
    setTextColor('judge','FFFFFF')
    end
    end
    setProperty('judge.alpha',1)
    setProperty('judge.scale.x',1.2)
	setProperty('judge.scale.y',1.2)
	doTweenX('ratingx','judge.scale', 1, 0.25, 'cubeOut')
	doTweenY('ratingy','judge.scale', 1, 0.25, 'cubeOut')
    doTweenAlpha('ratingalpha','judge',0,1,'ease')
end
function onTimerCompleted(tag, loops, loopsLeft)
if tag == 'Lag' then
	inputLag = false
end
end