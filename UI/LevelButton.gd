extends Button

var descriptionRef
var levelData

func init(descRef, data):
	text = data.name
	descriptionRef = descRef
	levelData = data 

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass


func _on_pressed():
	descriptionRef.append_text(levelData.description)
