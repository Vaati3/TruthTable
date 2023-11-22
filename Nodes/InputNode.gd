extends BaseNode
class_name InputNode

@export var amount: int = 2
@export var values: Array = [true, false]

func loadLevel(data):
	for output in outputs:
		output.queue_free()
	outputs.clear()
	
	nbOutputs = data.amount
	values = data.tests[1]
	
	var plugScene = preload(("res://Nodes/Base/Plug.tscn"))
	for i in range(nbOutputs):
		createConection(true, plugScene, i)
	
	for i in range(0, 2):
		if values[i]:
			outputs[i].color = Color.DARK_GREEN
			outputs[i].lineColour = Color.DARK_GREEN
		else:
			outputs[i].color = Color.DARK_RED
			outputs[i].lineColour = Color.DARK_RED

func _ready():
	type = NodeType.Input
	price = 0
	nbInputs = 0
	nbOutputs = amount
	super()

func updateAll(index : int) -> bool:
	return values[index]
