extends BaseNode
class_name OutputNode

@export var amount: int = 1
var values: Array[bool] = [false, false]
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

func _ready():
	type = NodeType.Output
	price = 0
	nbInputs = amount
	nbOutputs = 0
	super()

func updateAll(index : int) -> bool:
	for i in range(0, nbInputs):
		values[i] = inputs[i].updateLink()
	#add complete level logic
	return false
