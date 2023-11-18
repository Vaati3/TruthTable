extends Panel

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
	var inControl = Control.new()
	var outControl = Control.new()
	inControl.add_child(inputNode)
	outControl.add_child(outputNode)
	add_child(inControl)
	add_child(outControl)
