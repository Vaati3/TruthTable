extends Button

var levelData
var mainMenuRef : MainMenu

func init(menuRef, data):
	text = data.name
	levelData = data 
	mainMenuRef = menuRef

func _ready():
	pass # Replace with function body.

func _on_pressed():
	mainMenuRef.selectLevel(levelData)
