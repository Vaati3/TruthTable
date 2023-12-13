extends Button

var inputNodeRef : InputNode = null
var index : int = 0
var state : bool = false

func init(nodeRef:InputNode, i:int, b:bool):
	inputNodeRef = nodeRef
	index = i 
	state = b

func _on_pressed():
	$Audio.play(0.24)
	state = not state
	inputNodeRef.Toggle(index, state)
