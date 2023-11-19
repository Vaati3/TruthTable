extends ColorRect
class_name Plug

var isPluged : bool = false
var value : bool = false
var isInput : bool

var node : BaseNode

var isLinked : bool = false
var linked : Plug = null
#for outputs only
var allLink : Array[Plug] = []
var linkPos : Vector2

var index : int
var lineColour

func getMiddle(vector : Vector2, size : Vector2, scale : Vector2) -> Vector2:
	return Vector2(vector.x + (size.x * scale.x / 2), vector.y + (size.y * scale.y / 2))

func init(isOutput, parentNode, i):
	isInput = not isOutput
	node = parentNode
	linkPos = getMiddle(position, size, scale)
	index = i

func _ready():
	lineColour = Color.WHITE
	
func _process(delta):
	if not isPluged and isLinked:
		var newPos = get_viewport().get_mouse_position() - global_position
		var reDraw = newPos == linkPos
		if reDraw:
			linkPos = newPos
			queue_redraw()

func _draw():
	if isLinked:
		draw_line(getMiddle(position, size, scale), linkPos, lineColour, 10)

func _get_drag_data(_pos):
	var data = {
		"origin" = self
	}
	if isPluged and isInput:
		linked.reset()
		reset()
	isLinked = true
	return data

func _can_drop_data(_pos, data):
	if  data.origin.node == node or data.origin.isInput == isInput:
		return false
	return true

func reset():
	color = Color.WHITE
	lineColour = Color.WHITE
	isPluged = false
	isLinked = false
	linked = null
	allLink.clear()

func _drop_data(_pos, data):
	if isPluged:
		linked.reset()
		reset()
	isPluged = true
	linked = data.origin
	linked.isPluged = true
	linked.linked = self

	if isInput:
		linked.isLinked = false
		isLinked = true
		linkPos = getMiddle(linked.global_position - global_position, linked.size, linked.scale)
		linked.allLink.append(self)
		node.updateNode()
	else:
		linked.isLinked = true
		isLinked = false
		linked.linkPos = getMiddle(global_position - linked.global_position, size, scale)
		allLink.append(linked)
		linked.node.updateNode()

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			if (not is_drag_successful()) and (not isPluged and isLinked):
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

	if state:
		lineColour = Color.DARK_GREEN
		linked.lineColour = Color.DARK_GREEN
		color = Color.DARK_GREEN
		linked.color = Color.DARK_GREEN
	else:
		lineColour = Color.DARK_RED
		linked.lineColour = Color.DARK_RED
		color = Color.DARK_RED
		linked.color = Color.DARK_RED
	queue_redraw()
	return state
