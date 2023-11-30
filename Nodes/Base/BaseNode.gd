extends Node2D
class_name BaseNode

enum NodeType {
	Base, Input, Output,
	NAnd,
	Not, And,
	Or, XOr, NOr
}

var type : NodeType = NodeType.Base
var price : int = 0

var nbInputs : int = 0
var nbOutputs : int = 0
var inputs : Array[Plug] = []
var outputs : Array[Plug] = []

var inputPlugOrigin : Vector2 = Vector2(20, 30)
var outputPlugOrigin : Vector2 = Vector2(200, 30)
var plugOffset : int = 40

var canRemove : bool = true

func createConection(isOutput: bool, plugScene, i):
	var plug = plugScene.instantiate()
	plug.init(isOutput, self, i)
	add_child(plug)
	if isOutput:
		plug.position.x = outputPlugOrigin.x
		plug.position.y = outputPlugOrigin.y + (plugOffset * i)
		outputs.append(plug)
	else:
		plug.position.x = inputPlugOrigin.x
		plug.position.y = inputPlugOrigin.y + (plugOffset * i)
		inputs.append(plug)

func _ready():
	if not canRemove:
		$Button.visible = false
	$RichTextLabel.append_text("[center]" + NodeType.keys()[type] + "[/center]")
	var plugScene = preload(("res://Nodes/Base/Plug.tscn"))
	for i in range(nbInputs):
		createConection(false, plugScene, i)
	for j in range(nbOutputs):
		createConection(true, plugScene, j)

func updateNode():
	var index : int = 0
	var isLast : bool = true

	for plug in outputs:
		if plug.isPluged:
			if plug.isInput:
				plug.linked.node.updateNode()
			else:
				for link in plug.allLink:
					link.node.updateNode()
			index = plug.index
			isLast = false
	if isLast:
		updateAll(index)

func updateAll(index : int) -> bool:
	return false

func updateDrag(event):
	position += event.relative
	for plug in inputs:
		if plug.isLinked:
			plug.linkPos -= event.relative
			plug.queue_redraw()
	for plug in outputs:
		if plug.isPluged:
			for link in plug.allLink:
				link.linkPos += event.relative
				link.queue_redraw()

func _on_panel_gui_input(event):
	if event is InputEventScreenDrag:
		updateDrag(event)

func _on_rich_text_label_gui_input(event):
	if event is InputEventScreenDrag:
		updateDrag(event)

func _on_button_pressed():
	var parent = get_parent()
	if parent is GameMenu:
		for input in inputs:
			input.reset()
		for output in outputs:
			for link in output.allLink:
				link.reset()
		
		parent.nodeList.erase(self)
		queue_free()
