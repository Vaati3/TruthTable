extends BaseNode
class_name AndNode

var state : bool = false

func _ready():
	type = NodeType.And
	price = 2
	nbInputs = 2
	nbOutputs = 1
	super()

func updateLogic(index : int) -> bool:
	state = inputs[0].updateLink() and inputs[1].updateLink()
	return state
