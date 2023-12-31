extends Node

var which_player = 0
@onready var pl1 = $Player1
@onready var pl2 = $Player2
@onready var ap = $AnimationPlayer

func play_bgm(stream):
	if which_player == 0:
		which_player = 1
		pl1.stream = stream
		ap.play("FadeTo1")
	else:
		which_player = 0
		pl2.stream = stream
		ap.play("FadeTo2")
		
