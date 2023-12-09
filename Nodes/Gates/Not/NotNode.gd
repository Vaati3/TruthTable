extends BaseNode
class_name NotNode

var state : bool = false

func _ready():
	type = NodeType.Not
	nbInputs = 1
	nbOutputs = 1
	super()

func updateAll(_index : int) -> bool:
	return not inputs[0].updateLink()
