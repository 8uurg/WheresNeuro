extends Area2D

@export var hud_icon: Texture2D;
var interaction_key;

func _ready():
	# Inform central controller of our presence - and obtain a tag - one that we can use
	# in case we have been 'found'.
	interaction_key = InteractableRegistry.register_to_be_found(hud_icon)

func _input_event(_viewport, event, _shape_idx):
	# If the event indicates we have pressed a mouse button
	# and it indicates that this is the mouse down event
	# and it corresponds to the left mouse button event
	# we handle this as a click.
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		interact()

func interact():
	# Indicate that we have been found to the registry - note that some form of detection mechanism
	var newly_found = InteractableRegistry.found(interaction_key)
	
	if newly_found:
		$FoundSound.play()
