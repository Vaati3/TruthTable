extends BaseNode
class_name XOrNode

var state : bool = false
@export var isNot : bool = false

func _ready():
	if isNot:
		type = NodeType.XNOr
		$Panel/TextureRect.texture = load("res://Nodes/Gates/Or/xnor.png")
	else:
		type = NodeType.XOr
	nbInputs = 2
	nbOutputs = 1
	super()

func updateAll(_index : int) -> bool:
	var a : bool = inputs[0].updateLink()
	var b : bool = inputs[1].updateLink()
	state = (a or b) and not (a and b)
	if isNot: state = not state
	return state
