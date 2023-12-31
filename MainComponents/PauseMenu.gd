extends Panel
func toggle_pause():
	if get_tree().paused:
		unpause()
	else:
		pause()

func pause():
	get_tree().paused = true
	visible = true

func unpause():
	get_tree().paused = false
	visible = false
