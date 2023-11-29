extends BaseNode
class_name InputNode

@export var amount: int = 2
@export var values: Array = [true, false]

var btnList = []
var toggleBtnOffset: int = 45

func createToggleBtn(i:int, btnScene):
	var btn = btnScene.instantiate()
	btn.init(self, i, values[i])
	add_child(btn)
	btnList.append(btn)
	btn.position.x = outputPlugOrigin.x - toggleBtnOffset
	btn.position.y = outputPlugOrigin.y + (plugOffset * i)

func loadLevel(data):
	for output in outputs:
		output.queue_free()
	outputs.clear()
	for btn in btnList:
		btn.queue_free()
	btnList.clear()

	nbOutputs = data.amount
	values = data.tests[1]
	
	var plugScene = preload(("res://Nodes/Base/Plug.tscn"))
	var btnScene = preload(("res://Nodes/IO/ToggleButton.tscn"))
	for i in range(nbOutputs):
		createConection(true, plugScene, i)
		createToggleBtn(i, btnScene)
		if values[i]:
			outputs[i].color = Color.DARK_GREEN
			outputs[i].lineColour = Color.DARK_GREEN
		else:
			outputs[i].color = Color.DARK_RED
			outputs[i].lineColour = Color.DARK_RED

func _ready():
	type = NodeType.Input
	canRemove = false
	price = 0
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
