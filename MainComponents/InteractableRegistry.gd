extends Node

var idx = 0
var id_map = {}
var was_found = {}
var num_to_be_found = 0
var num_found = 0

var pending_elements = []
var hud_e

var tbfi = preload("res://MainComponents/to_be_found_item.tscn")

signal num_found_changed
signal all_found

# Clear any currently assigned tags.
func clear():
	# Remove all pre-existing texturerects'
	for e in hud_e.get_children():
		hud_e.remove_child(e)
	idx = 0
	id_map = {}

func register_laf_hud(e):
	hud_e = e
	for c in pending_elements:
		hud_e.add_child(c)
	pending_elements = []

# Register a new element that needs to be found.
func register_to_be_found(texture):
	# Key for this element will be the current index
	var key = idx
	# Increment index
	idx = idx + 1
	# Prepare texturerect
	if texture != null:
		var r = tbfi.instantiate(PackedScene.GenEditState.GEN_EDIT_STATE_MAIN_INHERITED)
		r.texture = texture
		if hud_e == null:
			pending_elements.push_back(r)
		else:
			hud_e.add_child(r)
		id_map[key] = r
		was_found[key] = false
		num_to_be_found += 1
	
	return key

func found(key):
	# Ignore clicks on elements that were already found.
	if was_found.get(key, true): return
	# Mark as found
	was_found[key] = true
	# Update.
	num_found += 1
	num_found_changed.emit(num_found)
	# Fade out the element, as to mark this as found.
	var hud_elem = id_map.get(key)
	# If there is no corresponding element, that is probably a bug - deal with it nicely
	# anyways by ignoring.
	if hud_elem == null: return
	# Otherwise, inform our hud element of the ongoing shenanigans.
	hud_elem.found()
	if num_found == num_to_be_found:
		all_found.emit()
	
