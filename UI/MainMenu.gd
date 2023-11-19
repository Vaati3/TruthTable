extends Control
class_name MainMenu

var data
var isPlayMenu : bool = false
var selectedLevel

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
		btn.init(self, level)
		var control = Control.new()
		control.add_child(btn)
		$MainMenu/LevelsScroll/Levels.add_child(control)

func _ready():
	if readfile():
		fillLevels()

func selectLevel(level):
	$MainMenu/DescriptionPanel/DescriptionText.clear()
	$MainMenu/DescriptionPanel/DescriptionText.append_text(level.description)
	selectedLevel = level

func _on_play_button_pressed():
	if isPlayMenu:
		isPlayMenu = false
		$MainMenu/LevelsScroll.visible = false
		$MainMenu/DescriptionPanel.visible = false
		$MainMenu/PlayMenu.visible = true
	else:
		isPlayMenu = true
		$MainMenu/PlayMenu.visible = false
		$MainMenu/LevelsScroll.visible = true
		$MainMenu/DescriptionPanel.visible = true

func _on_option_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	$MainMenu.visible = false
	$GameMenu.startLevel(selectedLevel)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _on_gui_input(event):
	if event is InputEventScreenDrag:
		$GameMenu.moveScreen(event.relative)
