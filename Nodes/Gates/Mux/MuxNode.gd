extends BaseNode
class_name MuxNode

func _ready():
	type = NodeType.Mux
	nbInputs = 3
	nbOutputs = 1
	super()

func updateAll(_index : int) -> bool:
	var a : bool = inputs[0].updateLink()
	var b : bool = inputs[1].updateLink()
	var sel : bool = inputs[2].updateLink()
	if sel:
		return a
	else:
		return b
