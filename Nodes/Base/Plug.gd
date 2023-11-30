extends ColorRect
class_name Plug

var isPluged : bool = false
var value : bool = false
var isInput : bool

var node : BaseNode

var isLinked : bool = false
var linked : Plug = null
var drawLine : bool = false
#for outputs only
var allLink : Array[Plug] = []
var linkPos : Vector2

var index : int
var lineColour = Color.WHITE

func getMiddle(vector : Vector2, size : Vector2, scale : Vector2) -> Vector2:
	return Vector2(vector.x + (size.x * scale.x / 2), vector.y + (size.y * scale.y / 2))

func init(isOutput, parentNode, i):
	isInput = not isOutput
	node = parentNode
	linkPos = getMiddle(Vector2(0, 0), size, scale)
	index = i

func _ready():
	lineColour = Color.WHITE
	
func _process(delta):
	if drawLine:
		linkPos = get_viewport().get_mouse_position() - global_position
		queue_redraw()

func _draw():
	if isLinked:
		draw_line(getMiddle(Vector2(0, 0), size, scale), linkPos, lineColour, 10)

func reset():
	if not isInput:
		return
	color = Color.WHITE
	isPluged = false
	isLinked = false
	if linked:
		linked.allLink.erase(self)
		if linked.allLink.size() == 0:
			linked.isPluged = false
		linked = null

func _get_drag_data(_pos):
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
	return true

func _drop_data(_pos, data):
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
		color = Color.DARK_GREEN
		if isPluged:
			linked.lineColour = Color.DARK_GREEN
			linked.color = Color.DARK_GREEN
	else:
		lineColour = Color.DARK_RED
		color = Color.DARK_RED
		if isPluged:
			linked.lineColour = Color.DARK_RED
			linked.color = Color.DARK_RED
	
	queue_redraw()
	if isPluged:
		linked.queue_redraw()
