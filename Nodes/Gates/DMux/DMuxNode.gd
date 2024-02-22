extends BaseNode
class_name DMuxNode

func _ready():
	type = NodeType.Mux
	nbInputs = 2
	nbOutputs = 2
	super()

func updateAll(index : int) -> bool:
	var a : bool = inputs[0].updateLink()
	var sel : bool = inputs[1].updateLink()

	if (sel and index == 0) or (not sel and index == 1):
		return a
	return 0
