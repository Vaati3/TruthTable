extends Control
class_name MainMenu

var data
var isPlayMenu : bool = false

func readfile() -> bool:
	var file = FileAccess.open("res://UI/data.json", FileAccess.READ)
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	
	if error == OK:
		data = json.data
		return true
	else:
		print("Error: Json parse failed")
		return false

func fillLevels():
	var btnScene = preload(("res://UI/LevelButton.tscn"))
	for level in data.levels:
		var btn = btnScene.instantiate()
		btn.init($DescriptionPanel/DescriptionText, level)
		var control = Control.new()
		control.add_child(btn)
		$ScrollContainer/Levels.add_child(control)

func _ready():
	if readfile():
		fillLevels()

func _process(delta):
	pass

func _on_play_button_pressed():
	if isPlayMenu:
		isPlayMenu = false
		$ScrollContainer.visible = false
		$DescriptionPanel.visible = false
		$MainMenu.visible = true
	else:
		isPlayMenu = true
		$MainMenu.visible = false
		$ScrollContainer.visible = true
		$DescriptionPanel.visible = true

func _on_option_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
