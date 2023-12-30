extends HBoxContainer

func _ready():
	InteractableRegistry.register_laf_hud(self)
