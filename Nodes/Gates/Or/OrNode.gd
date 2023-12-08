extends BaseNode
class_name OrNode

var state : bool = false
@export var isNot : bool = false

func _ready():
	if isNot:
		type = NodeType.NOr
		$TextureRect.texture = load("res://Nodes/Gates/Or/nor.png")
	else:
		type = NodeType.Or
	nbInputs = 2
	nbOutputs = 1
	super()

func updateAll(index : int) -> bool:
	var a : bool = inputs[0].updateLink()
	var b : bool = inputs[1].updateLink()
	state = a or b
	if isNot: state = not state
	return state
