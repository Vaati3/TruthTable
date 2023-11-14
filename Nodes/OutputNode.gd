extends BaseNode

@export var amount: int = 1
var values: Array[bool] = [false]

# Called when the node enters the scene tree for the first time.
func _ready():
	type = NodeType.Input
	price = 0
	nbInputs = amount
	nbOutputs = 0
	super()

func updateLogic(index : int) -> bool:
	values[index] = inputs[index].updateLink()
	return false
