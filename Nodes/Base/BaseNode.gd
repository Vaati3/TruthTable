extends Node2D
class_name BaseNode

enum NodeType {
	Base,
	Input, Output,
	Not,
	And, NAnd,
	Or, XOr, NOr
}

var type : NodeType = NodeType.Base
var price : int = 0

var nbInputs : int = 0
var nbOutputs : int = 0
var inputs : Array[Plug] = []
var outputs : Array[Plug] = []

func createConection(isOutput: bool, plugScene, i):
	var plug = plugScene.instantiate()
	plug.init(isOutput, self, i)
	var control = Control.new()
	control.add_child(plug)
	if isOutput:
		$OutputBox.add_child(control)
		outputs.append(plug)
	else:
		$InputBox.add_child(control)
		inputs.append(plug)

func _ready():
	$RichTextLabel.append_text("[center]" + NodeType.keys()[type] + "[/center]")
	var plugScene = preload(("res://Nodes/Base/Plug.tscn"))
	for i in range(nbInputs):
		createConection(false, plugScene, i)
	for j in range(nbOutputs):
		createConection(true, plugScene, j)

func _process(delta):
	pass

func updateLogic(index : int) -> bool:
	return false

func updateDrag(event):
	position += event.relative
	for plug in inputs:
		if plug.isLinked:
			plug.linkPos -= event.relative
			plug.queue_redraw()
	for plug in outputs:
		if plug.isPluged:
			plug.linked.linkPos += event.relative
			plug.linked.queue_redraw()

func _on_panel_gui_input(event):
	if event is InputEventScreenDrag:
		updateDrag(event)

func _on_rich_text_label_gui_input(event):
	if event is InputEventScreenDrag:
		updateDrag(event)
