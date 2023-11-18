extends ColorRect
class_name GameMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null
var levelData

func startLevel(data):
	visible = true
	inputNode.loadLevel(data.input)
	outputNode.loadLevel(data.output)

func _ready():
	inputNode = preload(("res://Nodes/InputNode.tscn")).instantiate()
	outputNode = preload(("res://Nodes/OutputNode.tscn")).instantiate()
	
	
	add_child(inputNode)
	add_child(outputNode)
	inputNode.position = Vector2(200, 300)
	outputNode.position = Vector2(800, 300)
	
#	var inControl = Control.new()
#	var outControl = Control.new()
#	inControl.add_child(inputNode)
#	outControl.add_child(outputNode)
#	add_child(inControl)
#	add_child(outControl)
#
#	inControl.position = Vector2(200, 300)
#	outControl.position = Vector2(800, 300)
