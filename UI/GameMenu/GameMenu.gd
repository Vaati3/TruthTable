extends ColorRect
class_name GameMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null
var levelData

var nodeList : Array[BaseNode] = []
var isSliderOut : bool = false
var sliderMoving : bool = false
var sliderSpeed : int = 7

#maybe add save system
func clearGame():
	for node in nodeList:
		node.queue_free()
	nodeList.clear()
	
	for child in $NodePanel/Scroll/HBoxContainer.get_children():
		child.queue_free()
	$SlidingPanel/DescriptionText.clear()

func fillNodesBtn():
	var btnScene = preload(("res://UI/GameMenu/NodeButton.tscn"))
	for i in range(levelData.nodeAvailable.size()):
		if levelData.nodeAvailable[i]:
			var btn = btnScene.instantiate()
			btn.init(self, BaseNode.NodeType.keys()[i+3], BaseNode.NodeType.values()[i+3])
			var control = Control.new()
			control.add_child(btn)
			$NodePanel/Scroll/HBoxContainer.add_child(control)

func fillDesc():
	$SlidingPanel/Label.text = levelData.name.replace("\n", " ")
	$SlidingPanel/DescriptionText.append_text(levelData.description)
	$SlidingPanel/Table.texture = load(levelData.table)
	$SlidingPanel/Table.scale = Vector2(levelData.tableScale.x, levelData.tableScale.y)

func startLevel(data):
	clearGame()
	visible = true
	toggleVisible(true)
	inputNode.loadLevel(data.input)
	outputNode.loadLevel(data.output)
	levelData = data
	fillNodesBtn()
	fillDesc()
	$VerifyPanel.initVerify(inputNode, outputNode, data)

func _ready():
	inputNode = preload("res://Nodes/IO/InputNode.tscn").instantiate()
	outputNode = preload("res://Nodes/IO/OutputNode.tscn").instantiate()
	inputNode.z_index = -100
	outputNode.z_index = -100
	
	add_child(inputNode)
	add_child(outputNode)
	inputNode.position = Vector2(300, 100)
	outputNode.position = Vector2(300, 800)
	

func moveScreen(relative):
	inputNode.position += relative
	outputNode.position += relative
	
	for node in nodeList:
		node.position += relative

func addNode(node : BaseNode):
	add_child(node)
	node.z_index = -100
	nodeList.append(node)
	
	node.position = Vector2(300, 400)

func removeNode(node : BaseNode):
	$Audio.play(0.24)
	nodeList.erase(node)

func toggleVisible(isVisible:bool):
	$NodePanel/Scroll/HBoxContainer.visible = isVisible
	$ValidateButton.visible = isVisible
	inputNode.visible = isVisible
	outputNode.visible = isVisible
	for node in nodeList:
		node.visible = isVisible

func _on_back_button_pressed():
	$Audio.play(0.24)
	toMainMenu()

func _on_button_pressed():
	$Audio.play(0.24)
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
	
	sliderMoving = false
	isSliderOut = false
	$NodePanel.reset()
