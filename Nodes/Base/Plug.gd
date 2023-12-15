extends Panel
class_name Plug

var isPluged : bool = false
var value : bool = false
var isInput : bool

var node : BaseNode

var isLinked : bool = false
var linked : Plug = null
var drawLine : bool = false
var linkPos : Vector2
#for outputs only
var allLink : Array[Plug] = []

var index : int
var lineColour = Color.WHITE
var box
var greenBox
var redBox

func init(isOutput, parentNode, i):
	isInput = not isOutput
	node = parentNode
	linkPos = getMiddle(Vector2(0, 0), size, scale)
	index = i

func _ready():
	lineColour = Color.WHITE
	box = get_theme_stylebox("panel").duplicate()
	greenBox = get_theme_stylebox("panel").duplicate()
	greenBox.bg_color = Color.DARK_GREEN
	redBox = get_theme_stylebox("panel").duplicate()
	redBox.bg_color = Color.DARK_RED

func _process(_delta):
	if drawLine:
		linkPos = get_viewport().get_mouse_position() - global_position
		queue_redraw()

func _draw():
	if isLinked:
		draw_line(getMiddle(Vector2(0, 0), size, scale), linkPos, lineColour, 10)

func getMiddle(vector : Vector2, sizes : Vector2, scales : Vector2) -> Vector2:
	return Vector2(vector.x + (sizes.x * scales.x / 2), vector.y + (sizes.y * scales.y / 2))

func setLabel(label):
	$Label.text = label

func reset():
	if not isInput:
		return
	add_theme_stylebox_override("panel", box)
	isPluged = false
	isLinked = false
	if linked:
		linked.allLink.erase(self)
		if linked.allLink.size() == 0:
			linked.isPluged = false
		linked = null

func _get_drag_data(_pos):
	$AudioTic.play()
	if isPluged and isInput:
		reset()
	var data = {
		"origin" = self
	}
	drawLine = true
	isLinked = true
	return data

func _can_drop_data(_pos, data):
	if  data.origin.node == node or data.origin.isInput == isInput:
		return false
	if not node.checkLoop(data.origin.node, isInput):
		return false
	return true

func _drop_data(_pos, data):
	$AudioPop.play(0.2)
	if isPluged:
		reset()
	drawLine = false
	isPluged = true
	linked = data.origin
	
	linked.isPluged = true
	linked.linked = self
	linked.drawLine = false
	linked.queue_redraw()

	if isInput:
		linked.isLinked = false
		isLinked = true
		linkPos = getMiddle(linked.global_position - global_position, linked.size, linked.scale)
		linked.allLink.append(self)
	else:
		linked.isLinked = true
		isLinked = false
		allLink.append(linked)
	
	node.updateNode()

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			if (not is_drag_successful()):
				if(drawLine):
					drawLine = false
					isLinked = false
					if isInput:
						reset()
					queue_redraw()

func updateLink() -> bool:
	if not isPluged:
		return false
	
	var state : bool
	if isInput:
		state = linked.node.updateAll(linked.index)
	else:
		state = node.updateAll(index)
	
	setColour(state)
	return state

func setColour(state: bool):
	if state:
		lineColour = Color.DARK_GREEN
		add_theme_stylebox_override("panel", greenBox)
		if isPluged:
			linked.lineColour = Color.DARK_GREEN
			linked.add_theme_stylebox_override("panel", greenBox)
	else:
		lineColour = Color.DARK_RED
		add_theme_stylebox_override("panel", redBox)
		if isPluged:
			linked.lineColour = Color.DARK_RED
			linked.add_theme_stylebox_override("panel", redBox)
	
	queue_redraw()
	if isPluged:
		linked.queue_redraw()
