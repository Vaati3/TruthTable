extends HSlider
class_name VolumeSlider

@export var label : String
@export var busName : String
@export var index : int

var busIndex : int = 0
var menuRef : MainMenu

func setVolume(volume):
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(volume))

func loadSave(menu):
	menuRef = menu
	value = menu.saveData.options.volume[index]
	$Mute.button_pressed = menu.saveData.options.muted[index]
	if $Mute.pressed:
		setVolume(0)
	else:
		setVolume(value)

func _ready():
	$Label.text = label
	busIndex = AudioServer.get_bus_index(busName)

func _on_value_changed(volume):
	menuRef.saveData.options.volume[index] = volume
	setVolume(volume)
	menuRef.save()

func _on_mute_toggled(button_pressed):
	menuRef.saveData.options.muted[index] = button_pressed
	if (button_pressed):
		setVolume(0)
	else:
		setVolume(value)
	menuRef.save()
