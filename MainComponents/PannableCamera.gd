extends Camera2D
class_name PannedCamera

const CAMERA_SPEED = 200.0

const ZOOM_MUL = 1.1
const ZOOM_DIV = 1 / ZOOM_MUL

var drag_ref = null
var before_drag_position = null
var zoom_lim = Vector2(-INF, -INF)

@export var max_zoom = INF

@export_category("set limit")
@export var limit_top_offset = 0.0
@export var limit_right_offset = 0.0
@export var limit_bottom_offset = 0.0
@export var limit_left_offset = 0.0

var bounds_top
var bounds_right
var bounds_bottom
var bounds_left


func set_bounds(bound_top, bound_right, bound_bottom, bound_left):
	limit_top = bound_top + limit_top_offset
	bounds_top = bound_top
	limit_right = bound_right + limit_right_offset
	bounds_right = bound_right
	limit_bottom = bound_bottom + limit_bottom_offset
	bounds_bottom = bound_bottom
	limit_left = bound_left + limit_left_offset
	bounds_left = bound_left

# Called when the node enters the scene tree for the first time.
func _ready():
	# Register a handler for dealing with window resizing.
	get_tree().get_root().connect("size_changed", on_size_changed)

func on_size_changed():
	# Window has been resized, limits might need to be adapted accordingly
	# otherwise the camera might be able to see outside the level.
	update_min_zoom()
	
func update_min_zoom():
	# Note: is called by Level's ready once the limits have been set.
	var viewport_size = get_viewport_rect().size

	const CORRECTION_NUM = 1
	var limit_horiz = viewport_size.x / (bounds_right - bounds_left - CORRECTION_NUM)
	var limit_vert =  viewport_size.y / (bounds_bottom - bounds_top - CORRECTION_NUM)
	limit_horiz = limit_horiz if is_finite(limit_horiz) else -INF
	limit_vert = limit_vert if is_finite(limit_vert) else -INF
	
	var lim = max(limit_horiz, limit_vert)
	
	zoom_lim = Vector2(lim, lim)
	
	clamp_zoom()
	
func clamp_zoom():
	zoom = zoom.clamp(zoom_lim, Vector2(max_zoom, max_zoom))

func clamp_correct():
	# Position may be arbitrarily of actual position far away if limits are set.
	position = get_screen_center_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clamp_correct()
	
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	var direction_vertical = Input.get_axis("ui_up", "ui_down")

	position.x += direction_horizontal * delta * CAMERA_SPEED;
	position.y +=  direction_vertical * delta * CAMERA_SPEED;

func _unhandled_input(event):
	# If mouse button is pressed, handle it
	# (note: does pressing the buttons at the bottom cause this event too?)
	if event is InputEventMouseButton:
		var mb_event = event as InputEventMouseButton
		
		# Dragging
		if mb_event.button_index == MOUSE_BUTTON_LEFT and mb_event.is_pressed():
			var t = get_global_transform_with_canvas().affine_inverse()
			before_drag_position = position
			drag_ref = t * mb_event.position
			
		elif mb_event.button_index == MOUSE_BUTTON_LEFT and mb_event.is_released():
			before_drag_position = null
			drag_ref = null
		
		# Zoom
		elif mb_event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= ZOOM_MUL
			clamp_zoom()
		elif mb_event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= ZOOM_DIV
			clamp_zoom()
	
	elif event is InputEventMouseMotion and not (drag_ref == null):
		clamp_correct()
		
		var t = get_global_transform_with_canvas().affine_inverse()
		var mm_event = event as InputEventMouseMotion
		var new_position = t * mm_event.position
		
		# How do we need to reposition the camera such that the coordinates
		# of the mouse (approximately) match the coordinates of its original position?
		position = before_drag_position + drag_ref - new_position
		
		# In case of clipping
		before_drag_position = position
		drag_ref = new_position
