extends Panel
class_name VerifyMenu

var inputNode : InputNode = null
var outputNode : OutputNode = null

var levelData

func initVerify(input:InputNode, output:OutputNode, data):
	inputNode = input
	outputNode = output
	levelData = data
	
	$RichTextLabel.clear()
	$RichTextLabel.append_text(levelData.name)
	
	var testScn = preload("res://UI/GameMenu/TestElement.tscn")
	for i in range(levelData.input.tests.size()):
		var test = testScn.instantiate()
		test.init("Test "  + str(i + 1))
		$TestBox.add_child(test)

func openAndRunTest():
	visible = true
	var save = inputNode.values
	var tests = levelData.input.tests
	var results = levelData.output.results
	var elements = $TestBox.get_children()
	
	for i in range(tests.size()):
		inputNode.values = tests[i]
		inputNode.updateNode()
		elements[i].updateResult(outputNode.values == results[i])
	
	inputNode.values = save
	inputNode.updateNode()

func _on_back_button_pressed():
	visible = false

func _on_menu_button_pressed():
	get_parent().visible = false
	#to complete
