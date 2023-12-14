extends HSlider

@export var label : String
@export var busName : String

var busIndex : int = 0

func setVolume(volume):
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(volume))

func loadSave(volume):
	value = volume
	setVolume(volume)

func _ready():
	$Label.text = label
	busIndex = AudioServer.get_bus_index(busName)

func _on_value_changed(volume):
	setVolume(volume)

func _on_mute_toggled(button_pressed):
	if (button_pressed):
		setVolume(0)
	else:
		setVolume(value)
