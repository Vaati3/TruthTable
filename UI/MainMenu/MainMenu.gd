extends Control
class_name MainMenu

var data
var isPlayMenu : bool = false
var isPlaying : bool = false
var selectedLevel

var saveData = {
	"unlockedLevels": [true, false, false],
	"scoreList": [0, 0, 0]
}

func save():
	var saveFile = FileAccess.open("user://save.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(saveData)
	
	saveFile.store_line(jsonString)

func loadSave():
	if not FileAccess.file_exists("user://save.save"):
		return
	var saveFile = FileAccess.open("user://save.save", FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(saveFile.get_as_text())
	
	if error == OK:
		saveData.unlockedLevels = json.data.unlockedLevels
		saveData.scoreList = json.data.scoreList

func readLevelData() -> bool:
	if not FileAccess.file_exists("res://data.json"):
		return false
	var file = FileAccess.open("res://data.json", FileAccess.READ)
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	
	if error == OK:
		data = json.data
		return true
	else:
		print("Error: Json parse failed")
		return false

func fillLevels():
	for child in $MainMenu/LevelsScroll/Levels.get_children():
		child.queue_free()
	var btnScene = preload(("res://UI/MainMenu/LevelButton.tscn"))
	for level in data.levels:
		if saveData.unlockedLevels[level.id]:
			var btn = btnScene.instantiate()
			btn.init(self, level)
			var control = Control.new()
			control.add_child(btn)
			$MainMenu/LevelsScroll/Levels.add_child(control)

func _ready():
	if readLevelData():
		loadSave()
		fillLevels()

func selectLevel(level):
	$MainMenu/DescriptionPanel/DescriptionText.clear()
	$MainMenu/DescriptionPanel/DescriptionText.append_text(level.description)
	selectedLevel = level

func updateScore(nodeList : Array[BaseNode]):
	var score = 0
	
	if saveData.unlockedLevels[selectedLevel.id+1] == false:
		saveData.unlockedLevels[selectedLevel.id+1] = true
		fillLevels()
	for node in nodeList:
		if node.type == BaseNode.NodeType.NAnd:
			score += 1
		else:
			score += saveData.scoreList[node.type - 4]
	saveData.scoreList[selectedLevel.id] = score
	save()

func showMainMenu():
	isPlaying = false
	$MainMenu.visible = true

func _on_play_button_pressed():
	if isPlayMenu:
		isPlayMenu = false
		$MainMenu/LevelsScroll.visible = false
		$MainMenu/DescriptionPanel.visible = false
		$MainMenu/Menu.visible = true
	else:
		isPlayMenu = true
		$MainMenu/Menu.visible = false
		$MainMenu/LevelsScroll.visible = true
		$MainMenu/DescriptionPanel.visible = true

func _on_option_button_pressed():
	pass # show option menu to be added.

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	$MainMenu.visible = false
	isPlaying = true
	$GameMenu.startLevel(selectedLevel)

func _on_button_pressed():
	isPlayMenu = false
	$MainMenu/LevelsScroll.visible = false
	$MainMenu/DescriptionPanel.visible = false
	$MainMenu/Menu.visible = true

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if isPlayMenu:
			isPlayMenu = false
			$MainMenu/LevelsScroll.visible = false
			$MainMenu/DescriptionPanel.visible = false
			$MainMenu/Menu.visible = true
		elif isPlaying:
			GameMenu.visible = false
			showMainMenu()
		else:
			get_tree().quit()

func _on_gui_input(event):
	if isPlaying:
		if event is InputEventScreenDrag:
			$GameMenu.moveScreen(event.relative)
