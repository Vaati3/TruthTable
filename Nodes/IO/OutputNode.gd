extends BaseNode
class_name OutputNode

@export var amount: int = 1
var values: Array[bool] = [false]
var outputData

func loadLevel(data):
	for input in inputs:
		input.queue_free()
	inputs.clear()
	
	nbInputs = data.amount
	outputData = data
	
	var plugScene = preload(("res://Nodes/Base/Plug.tscn"))
	for i in range(nbInputs):
		createConection(false, plugScene, i)
	scaleNode()

func _ready():
	type = NodeType.Output
	canRemove = false
	nbInputs = amount
	nbOutputs = 0
	super()

func updateAll(_index : int) -> bool:
	for i in range(nbInputs):
		values[i] = inputs[i].updateLink()
	#add complete level logic
	return false
