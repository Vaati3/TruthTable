extends BaseNode
class_name InputNode

@export var amount: int = 0
@export var values: Array = []

var btnList = []
var toggleBtnOffset: int = 95

func createToggleBtn(i:int, btnScene):
	var btn = btnScene.instantiate()
	btn.init(self, i, values[i])
	add_child(btn)
	btnList.append(btn)
	btn.position.x = outputPlugOrigin.x + (plugOffset * i) + btn.size.x / 2
	btn.position.y = outputPlugOrigin.y - toggleBtnOffset/2

func loadLevel(data):
	for output in outputs:
		output.queue_free()
	outputs.clear()
	for btn in btnList:
		btn.queue_free()
	btnList.clear()

	nbOutputs = data.amount
	values = data.tests[0].duplicate()
	
	var plugScene = preload(("res://Nodes/Base/Plug.tscn"))
	var btnScene = preload(("res://Nodes/IO/ToggleButton.tscn"))
	for i in range(nbOutputs):
		createConection(true, plugScene, i)
		createToggleBtn(i, btnScene)
		outputs[i].setColour(values[i])
		outputs[i].setLabel(data.labels[i])
	scaleNode()

func _ready():
	type = NodeType.Input
	canRemove = false
	nbInputs = 0
	nbOutputs = amount
	super()

func updateAll(index : int) -> bool:
	return values[index]

func Toggle(index:int, state:bool):
	values[index] = state
	if outputs[index].isPluged:
		updateNode()
	else:
		outputs[index].setColour(state)
