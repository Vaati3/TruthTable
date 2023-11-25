extends BaseNode
class_name AndNode

var state : bool = false
@export var isNot : bool = false

func _ready():
	if isNot:
		type = NodeType.NAnd
	else:
		type = NodeType.And
	price = 2
	nbInputs = 2
	nbOutputs = 1
	super()

func updateAll(index : int) -> bool:
	var a : bool = inputs[0].updateLink()
	var b : bool = inputs[1].updateLink()
	state = a and b
	if isNot: state = not state
	return state
