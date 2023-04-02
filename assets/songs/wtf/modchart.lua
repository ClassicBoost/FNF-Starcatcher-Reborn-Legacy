function onCreatePost()
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'poptop_sing_loop_baby');
end
function onSongStart()
	noteTweenX('moveNoteX0', 0, 416, 0.1, 'elasticIn');
	noteTweenX('moveNoteX1', 1, 528, 0.1, 'elasticIn');
	noteTweenX('moveNoteX2', 2, 640, 0.1, 'elasticIn');
	noteTweenX('moveNoteX3', 3, 752, 0.1, 'elasticIn');

	noteTweenX('moveNoteX4', 4, 416, 0.1, 'elasticIn');
	noteTweenX('moveNoteX5', 5, 528, 0.1, 'elasticIn');
	noteTweenX('moveNoteX6', 6, 640, 0.1, 'elasticIn');
	noteTweenX('moveNoteX7', 7, 752, 0.1, 'elasticIn');
	for i = 0, 3 do
		noteTweenAlpha('alphaNote' .. i, i, 0, 0.01, 'linear')
	end
end