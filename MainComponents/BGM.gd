extends Node

@export var stream: AudioStream

func _ready():
	BgmPlayer.play_bgm(stream)
