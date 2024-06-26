extends Button

var nodeName : String
var nodeType : BaseNode.NodeType

var parentGui : GameMenu

func loadTexture():
	match nodeType:
		BaseNode.NodeType.NAnd:
			return load("res://Nodes/Gates/And/nandIcon.png")
		BaseNode.NodeType.Not:
			return load("res://Nodes/Gates/Not/not.png")
		BaseNode.NodeType.And:
			return load("res://Nodes/Gates/And/andIcon.png")
		BaseNode.NodeType.Or:
			return load("res://Nodes/Gates/Or/or.png")
		BaseNode.NodeType.NOr:
			return load("res://Nodes/Gates/Or/nor.png")
		BaseNode.NodeType.XOr:
			return load("res://Nodes/Gates/Or/xor.png")
		BaseNode.NodeType.XNOr:
			return load("res://Nodes/Gates/Or/xnor.png")
		BaseNode.NodeType.Mux:
			return load("res://Nodes/Gates/Mux/muxIcon.png")
		BaseNode.NodeType.DMux:
			return load("res://Nodes/Gates/DMux/dmuxIcon.png")

func init(gui, nameNode, type):
	parentGui = gui
	
	nodeName = nameNode
	nodeType = type
	$Label.text = BaseNode.NodeType.keys()[nodeType]
	$TextureRect.texture = loadTexture()

func _on_pressed():
	$Audio.play(0.24)
	match nodeType:
		BaseNode.NodeType.And, BaseNode.NodeType.NAnd:
			var node = preload(("res://Nodes/Gates/And/AndNode.tscn")).instantiate()
			if nodeType == BaseNode.NodeType.NAnd: node.isNot = true
			parentGui.addNode(node)
		BaseNode.NodeType.Not:
			parentGui.addNode(preload(("res://Nodes/Gates/Not/NotNode.tscn")).instantiate())
		BaseNode.NodeType.Or, BaseNode.NodeType.NOr:
			var node = preload(("res://Nodes/Gates/Or/OrNode.tscn")).instantiate()
			if nodeType == BaseNode.NodeType.NOr: node.isNot = true
			parentGui.addNode(node)
		BaseNode.NodeType.XOr, BaseNode.NodeType.XNOr:
			var node = preload(("res://Nodes/Gates/Or/XOrNode.tscn")).instantiate()
			if nodeType == BaseNode.NodeType.XNOr: node.isNot = true
			parentGui.addNode(node)
		BaseNode.NodeType.Mux:
			parentGui.addNode(preload(("res://Nodes/Gates/Mux/MuxNode.tscn")).instantiate())
		BaseNode.NodeType.DMux:
			parentGui.addNode(preload(("res://Nodes/Gates/DMux/DMuxNode.tscn")).instantiate())
