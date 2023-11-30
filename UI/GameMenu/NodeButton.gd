extends Button

var nodeName : String
var nodeType : BaseNode.NodeType

var parentGui

func init(gui, name, type):
	parentGui = gui
	
	nodeName = name
	nodeType = type
	text = BaseNode.NodeType.keys()[nodeType]


func _on_pressed():
	match nodeType:
		BaseNode.NodeType.And:
			var node = preload(("res://Nodes/Gates/AndNode.tscn")).instantiate()
			node.isNot = false
			parentGui.addNode(node)
		BaseNode.NodeType.NAnd:
			var node = preload(("res://Nodes/Gates/AndNode.tscn")).instantiate()
			node.isNot = true
			parentGui.addNode(node)
