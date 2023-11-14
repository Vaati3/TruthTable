extends BaseNode
class_name InputNode

@export var amount: int = 2
@export var values: Array[bool] = [true, true]

func _ready():
	type = NodeType.Input
	price = 0
	nbInputs = 0
	nbOutputs = amount
	super()

func updateLogic(index : int) -> bool:
	return values[index]
