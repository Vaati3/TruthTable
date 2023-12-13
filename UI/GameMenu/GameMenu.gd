extends ColorRect
class_name GameMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null
var levelData

var nodeList : Array[BaseNode] = []
var isSliderOut : bool = false
var sliderMoving : bool = false
var sliderSpeed : int = 6

#maybe add save system
func clearGame():
	for node in nodeList:
		node.queue_free()
	nodeList.clear()
	
	for child in $Panel/HBoxContainer.get_children():
		child.queue_free()

func fillNodesBtn():
	var btnScene = preload(("res://UI/GameMenu/NodeButton.tscn"))
	for i in range(levelData.nodeAvailable.size()):
		if levelData.nodeAvailable[i]:
			var btn = btnScene.instantiate()
			btn.init(self, BaseNode.NodeType.keys()[i+3], BaseNode.NodeType.values()[i+3])
			var control = Control.new()
			control.add_child(btn)
			$Panel/HBoxContainer.add_child(control)

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
	inputNode.position = Vector2(300, 100)
	outputNode.position = Vector2(300, 800)

func _process(_delta):
	if sliderMoving:
		var screenheight = get_viewport_rect().size.y
		if isSliderOut:
			$Panel.position.y -= sliderSpeed
			if $Panel.position.y <= screenheight - $Panel.size.y:
				$Panel.position.y = screenheight - $Panel.size.y
				sliderMoving = false
		else:
			$Panel.position.y += sliderSpeed
			if $Panel.position.y >= screenheight:
				$Panel.position.y = screenheight
				sliderMoving = false

func moveScreen(relative):
	inputNode.position += relative
	outputNode.position += relative
	
	for node in nodeList:
		node.position += relative

func addNode(node : BaseNode):
	add_child(node)
	nodeList.append(node)
	
	node.position = Vector2(300, 400)

func toggleVisible(isVisible:bool):
	$Panel/HBoxContainer.visible = isVisible
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

func _on_slider_button_pressed():
	$Audio.play(0.24)
	sliderMoving = true
	if isSliderOut:
		isSliderOut = false
	else:
		isSliderOut = true

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
	$Panel.position.y = get_viewport_rect().size.y
