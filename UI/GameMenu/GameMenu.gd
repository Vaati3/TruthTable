extends ColorRect
class_name GameMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null
var levelData

var nodeList : Array[BaseNode] = []

#maybe add save system
func clearGame():
	for node in nodeList:
		node.queue_free()
	nodeList.clear()
	
	for child in $HBoxContainer.get_children():
		child.queue_free()

func fillNodesBtn():
	var btnScene = preload(("res://UI/GameMenu/nodeButton.tscn"))
	for i in range(levelData.nodeAvailable.size()):
		if levelData.nodeAvailable[i]:
			var btn = btnScene.instantiate()
			btn.init(self, BaseNode.NodeType.keys()[i+3], BaseNode.NodeType.values()[i+3])
			var control = Control.new()
			control.add_child(btn)
			$HBoxContainer.add_child(control)

func startLevel(data):
	clearGame()
	visible = true
	toggleVisible(true)
	inputNode.loadLevel(data.input)
	outputNode.loadLevel(data.output)
	levelData = data
	fillNodesBtn()
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

func toggleVisible(isVisible:bool):
	$HBoxContainer.visible = isVisible
	$Button.visible = isVisible
	inputNode.visible = isVisible
	outputNode.visible = isVisible
	for node in nodeList:
		node.visible = isVisible
func _on_button_pressed():
	toggleVisible(false)
	$VerifyPanel.openAndRunTest()

func updateScore():
	var parent = get_parent()
	
	if parent is MainMenu:
		parent.updateScore(nodeList)

func toMainMenu():
	var parent = get_parent()
	
	if parent is MainMenu:
		visible = false
		parent.showMainMenu()
