extends CanvasLayer
# class_name SceneSwitcher

var progress = 0.0
var fading = false
var loading = false
var loading_scene = null
var on_scene_unload = null

var switching = false

func _process(_delta):
	if loading_scene != null:
		# Get loading status
		var progress_arr = [0.0]
		var status = ResourceLoader.load_threaded_get_status(loading_scene, progress_arr)
		progress = progress_arr[0]
		# Note - here maybe update progress bar
		pass
		# If load completed - update the progress bar & update state
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			on_load_complete()
	else:
		progress = 0.0

func get_current_scene_url():
	return get_tree().current_scene.scene_file_path

func switch_to_scene(scene, _transition=""):
	# Ignore switches to null.
	if not scene: return
	# If already switching scenes
	if switching: return
	
	fading = true
	loading = true
	switching = true
	# Start loading scene
	loading_scene = scene
	ResourceLoader.load_threaded_request(scene)
	# Start loading animation
	$AnimationPlayer.play("fade_in")
	print("starting fade")

func fade_in_completed():
	# Fade in completed:
	# if resourceloader is done loading, switch.
	# otherwise, wait (until resourceloader completes)
	fading = false
	print("completed fade")
	if not loading:
		switch_and_fade_out()

func on_load_complete():
	loading = false
	if not fading:
		switch_and_fade_out()

func switch_and_fade_out():
	# Get scene & switch
	var scene_loaded = ResourceLoader.load_threaded_get(loading_scene)
	get_tree().change_scene_to_packed(scene_loaded)
	# Unpause scene
	get_tree().paused = false
	# Done!
	switching = false
		
	# Fade out
	$AnimationPlayer.play("fade_out")
	print("fading out")
	
