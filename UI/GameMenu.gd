extends ColorRect
class_name GameMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null
var levelData

var nodeList : Array[BaseNode] = []

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

func moveScreen(relative):
	inputNode.position += relative
	outputNode.position += relative
	
	for node in nodeList:
		node.position += relative
