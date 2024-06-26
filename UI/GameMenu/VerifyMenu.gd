extends Panel
class_name VerifyMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null

var levelData

func initVerify(input:InputNode, output:OutputNode, data):
	inputNode = input
	outputNode = output
	levelData = data
	
	$Label.text = levelData.name.replace("\n", " ")
	
	for test in $TestBox.get_children():
		test.queue_free()
	
	var testScn = preload("res://UI/GameMenu/TestElement.tscn")
	for i in range(levelData.input.tests.size()):
		var test = testScn.instantiate()
		test.init(" : " + str(i + 1))
		$TestBox.add_child(test)

func openAndRunTest():
	visible = true
	var save = inputNode.values
	var tests = levelData.input.tests
	var results = levelData.output.results
	var elements = $TestBox.get_children()
	var score :int = 0
	
	for i in range(tests.size()):
		inputNode.values = tests[i]
		inputNode.updateNode()
		
		var res : bool = outputNode.values == results[i]
		elements[i].updateResult(res)
		if res:
			score += 1
	
	if (score == tests.size()):
		var parent = get_parent()
		if parent is GameMenu:
			parent.updateScore()
	inputNode.values = save
	inputNode.updateNode()

func _on_back_button_pressed():
	$Audio.play(0.24)
	visible = false
	var parent = get_parent()
	if parent is GameMenu:
		parent.toggleVisible(true)

func _on_menu_button_pressed():
	$Audio.play(0.24)
	var parent = get_parent()
	
	if parent is GameMenu:
		visible = false
		parent.toMainMenu()
