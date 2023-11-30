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
		BaseNode.NodeType.And, BaseNode.NodeType.NAnd:
			var node = preload(("res://Nodes/Gates/And/AndNode.tscn")).instantiate()
			if nodeType == BaseNode.NodeType.NAnd: node.isNot = true
			parentGui.addNode(node)
		BaseNode.NodeType.Or, BaseNode.NodeType.NOr:
			var node = preload(("res://Nodes/Gates/Or/OrNode.tscn")).instantiate()
			if nodeType == BaseNode.NodeType.NOr: node.isNot = true
			parentGui.addNode(node)
		BaseNode.NodeType.XOr, BaseNode.NodeType.XNOr:
			var node = preload(("res://Nodes/Gates/Or/XOrNode.tscn")).instantiate()
			if nodeType == BaseNode.NodeType.XNOr: node.isNot = true
			parentGui.addNode(node)
