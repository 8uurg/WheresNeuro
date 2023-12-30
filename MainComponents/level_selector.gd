extends Button

@export_file var target_scene

func _pressed():
	SceneSwitcher.switch_to_scene(target_scene)
