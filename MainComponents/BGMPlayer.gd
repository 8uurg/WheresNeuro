extends Node

var which_player = 0
@onready var pl1 = $Player1
@onready var pl2 = $Player2
@onready var ap = $AnimationPlayer
var initial = true

func play_bgm(stream):
	if which_player == 0:
		# If already playing - don't restart
		if pl2.stream == stream: return
		which_player = 1
		pl1.stream = stream
		if initial:
			ap.play("QuickFade1")
		else:
			ap.play("FadeTo1")
	else:
		# If already playing - don't restart
		if pl1.stream == stream: return
		which_player = 0
		pl2.stream = stream
		ap.play("FadeTo2")
		
