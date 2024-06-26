extends BaseNode
class_name AndNode

var state : bool = false
@export var isNot : bool = false

func _ready():
	if isNot:
		type = NodeType.NAnd
		$Panel/TextureRect.texture = load("res://Nodes/Gates/And/nandIcon.png")
	else:
		type = NodeType.And
	nbInputs = 2
	nbOutputs = 1
	super()

func updateAll(_index : int) -> bool:
	var a : bool = inputs[0].updateLink()
	var b : bool = inputs[1].updateLink()
	state = a and b
	if isNot: state = not state
	return state
