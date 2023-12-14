extends Control
class_name MainMenu

var data
enum MenuState {
	StartMenu,
	LevelMenu,
	OptionMenu,
	GameMenu
}
var state : MenuState =  MenuState.StartMenu
var selectedLevel

var saveData = {
	"unlockedLevels": [],
	"scoreList": []
}

func save():
	var saveFile = FileAccess.open("user://save.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(saveData)
	
	saveFile.store_line(jsonString)

func loadSave():
	if not FileAccess.file_exists("user://save.save"):
		for i in range(data.levels.size()):
			saveData.unlockedLevels.append(false)
			saveData.scoreList.append(0)
		saveData.unlockedLevels[0] = true
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

func playMusic():
	$Music.stream = load("res://Sounds/music" + str(randi_range(1, 3)) + ".mp3")
	$Music.play()

func _ready():
	if readLevelData():
		loadSave()
		fillLevels()
		playMusic()

func selectLevel(level):
	$MainMenu/DescriptionPanel/Label.text = level.name
	$MainMenu/DescriptionPanel/DescriptionText.clear()
	$MainMenu/DescriptionPanel/DescriptionText.append_text(level.description)
	$MainMenu/DescriptionPanel/table.texture = load(level.table)
	$MainMenu/DescriptionPanel/table.scale = Vector2(level.tableScale.x, level.tableScale.y)
	$MainMenu/DescriptionPanel/ScoreText.clear()
	$MainMenu/DescriptionPanel/ScoreText.append_text("Can be done using only " + str(level.minScore) + " NAnd gates\n")
	if saveData.scoreList[level.id] > 0:
		$MainMenu/DescriptionPanel/ScoreText.append_text("Your best solution used " + str(saveData.scoreList[level.id]) + " NAnd gates")
	else:
		$MainMenu/DescriptionPanel/ScoreText.append_text("You have yet to complete this level")
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
	state = MenuState.LevelMenu
	$MainMenu.visible = true

#Main Menu button
func _on_play_button_pressed():
	$Audio.play(0.24)
	state = MenuState.LevelMenu
	$MainMenu/Menu.visible = false
	$MainMenu/Title.visible = false
	$MainMenu/LevelsScroll.visible = true
	$MainMenu/DescriptionPanel.visible = true

func _on_option_button_pressed():
	$Audio.play(0.24)
	state = MenuState.OptionMenu
	$MainMenu/Menu.visible = false
	$MainMenu/Title.visible = false
	$MainMenu/OptionMenu.visible = true

func _on_quit_button_pressed():
	$Audio.play(0.24)
	get_tree().quit()

#Level select buttons
func _on_start_button_pressed():
	$Audio.play(0.24)
	$MainMenu.visible = false
	state = MenuState.GameMenu
	$GameMenu.startLevel(selectedLevel)

func _on_button_pressed():
	$Audio.play(0.24)
	state = MenuState.StartMenu
	$MainMenu/LevelsScroll.visible = false
	$MainMenu/DescriptionPanel.visible = false
	$MainMenu/Title.visible = true
	$MainMenu/Menu.visible = true

#option menu buttons
func _on_quit_option_pressed():
	$Audio.play(0.24)
	state = MenuState.StartMenu
	$MainMenu/OptionMenu.visible = false
	$MainMenu/Menu.visible = true
	$MainMenu/Title.visible = true

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		match(state):
			MenuState.LevelMenu, MenuState.OptionMenu:
				state = MenuState.StartMenu
				$MainMenu/LevelsScroll.visible = false
				$MainMenu/DescriptionPanel.visible = false
				$MainMenu/Title.visible = true
				$MainMenu/Menu.visible = true
			MenuState.GameMenu:
				GameMenu.visible = false
				showMainMenu()
			_:
				get_tree().quit()

func _on_gui_input(event):
	if state == MenuState.GameMenu:
		if event is InputEventScreenDrag:
			$GameMenu.moveScreen(event.relative)
