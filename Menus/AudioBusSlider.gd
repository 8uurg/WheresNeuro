extends HSlider

@export var bus_name: String
@onready var bus_idx = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_idx))

func _value_changed(new_value):
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(new_value))
