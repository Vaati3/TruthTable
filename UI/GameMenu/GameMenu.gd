extends ColorRect
class_name GameMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null
var levelData

var nodeTypes
var nodeList : Array[BaseNode] = []

func fillNodes():
	var btnScene = preload(("res://UI/GameMenu/nodeButton.tscn"))
	for type in nodeTypes:
		var btn = btnScene.instantiate()
		btn.init(self, type)
		var control = Control.new()
		control.add_child(btn)
		$HBoxContainer.add_child(control)

func startLevel(data, nodes):
	visible = true
	inputNode.loadLevel(data.input)
	outputNode.loadLevel(data.output)
	levelData = data
	nodeTypes = nodes
	fillNodes()
	$VerifyPanel.initVerify(inputNode, outputNode, data)

func _ready():
	inputNode = preload("res://Nodes/IO/InputNode.tscn").instantiate()
	outputNode = preload("res://Nodes/IO/OutputNode.tscn").instantiate()
	
	add_child(inputNode)
	add_child(outputNode)
	inputNode.position = Vector2(200, 300)
	outputNode.position = Vector2(800, 300)

func moveScreen(relative):
	inputNode.position += relative
	outputNode.position += relative
	
	for node in nodeList:
		node.position += relative

func addNode(node : BaseNode):
	add_child(node)
	nodeList.append(node)
	
	node.position = Vector2(400, 300)

func _on_button_pressed():
	$VerifyPanel.openAndRunTest()
