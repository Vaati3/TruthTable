extends Node2D
class_name BaseNode

enum NodeType {
	Base, Input, Output,
	NAnd, Not, And,
	Or, NOr, XOr, XNOr,
	Mux, DMux
}

var type : NodeType = NodeType.Base

var nbInputs : int = 0
var nbOutputs : int = 0
var inputs : Array[Plug] = []
var outputs : Array[Plug] = []

var inputPlugOrigin : Vector2 = Vector2(25, -20)
var outputPlugOrigin : Vector2 = Vector2(25, 150)
var plugOffset : int = 95

var canRemove : bool = true

func createConection(isOutput: bool, plugScene, i):
	var plug = plugScene.instantiate()
	plug.init(isOutput, self, i)
	add_child(plug)
	if isOutput:
		plug.position.x = outputPlugOrigin.x + (plugOffset * i)
		plug.position.y = outputPlugOrigin.y 
		outputs.append(plug)
	else:
		plug.position.x = inputPlugOrigin.x + (plugOffset * i)
		plug.position.y = inputPlugOrigin.y
		inputs.append(plug)

func scaleNode():
	var n:int = max(nbInputs, nbOutputs)
	
	if nbInputs == 1:
		inputPlugOrigin.x += plugOffset - 25
	if nbOutputs == 1:
		outputPlugOrigin.x += plugOffset - 25
	if n > 2:
		$Panel.size.x += (n - 2) * (plugOffset)

func _ready():
	if not canRemove:
		$Button.visible = false
	$Panel/RichTextLabel.append_text("[center]" + NodeType.keys()[type] + "[/center]")
	scaleNode()
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

func updateAll(_index : int) -> bool:
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

#not very good but works
func checkLoop(newNode:BaseNode, isInput:bool) -> bool:
	var res:bool = true
	if newNode == self:
		return false
	if isInput:
		for output in outputs:
			if output.isPluged:
				for link in output.allLink:
					if not link.node.checkLoop(newNode, isInput): return false
	else:
		for input in inputs:
			if input.isPluged:
				if not input.linked.node.checkLoop(newNode, isInput) : return false
	return res

func _on_panel_gui_input(event):
	if event is InputEventScreenDrag:
		updateDrag(event)

func _on_rich_text_label_gui_input(event):
	if event is InputEventScreenDrag:
		updateDrag(event)

func _on_button_pressed():
	$Button/Audio.play(0.24)
	var parent = get_parent()
	if parent is GameMenu:
		for input in inputs:
			input.reset()
		for output in outputs:
			for link in output.allLink:
				link.reset()
		
		parent.nodeList.erase(self)
		queue_free()



