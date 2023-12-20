extends Button
class_name LevelButton

var levelData
var mainMenuRef : MainMenu

func init(menuRef, data):
	text = data.name
	levelData = data 
	mainMenuRef = menuRef

func unselect():
	set_pressed_no_signal(false)

func _on_pressed():
	$Audio.play(0.24)
	mainMenuRef.selectLevel(levelData)
