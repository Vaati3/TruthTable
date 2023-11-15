extends ColorRect
class_name Plug

var isPluged : bool = false
var value : bool = false
var isInput : bool

var node : BaseNode

var isLinked : bool = false
var linked : Plug = null
var linkPos : Vector2

var index : int
var colour = Color.WHITE

func getMiddle(vector : Vector2, size : Vector2, scale : Vector2) -> Vector2:
	return Vector2(vector.x + (size.x * scale.x / 2), vector.y + (size.y * scale.y / 2))

func init(isOutput, parentNode, i):
	isInput = not isOutput
	node = parentNode
	linkPos = getMiddle(position, size, scale)
	index = i

func _ready():
	pass

func _draw():
	if isLinked:
		draw_line(getMiddle(position, size, scale), linkPos, colour, 10)

func _process(delta):
	pass

func _on_gui_input(event):
	if event is InputEventScreenDrag:
		if isPluged and isInput:
			linked.reset()
			reset()
		if not isLinked:
			isLinked = true
			linkPos = position
		linkPos += event.relative
		queue_redraw()

func _get_drag_data(_pos):
	var data = {
		"origin" = self
	}
	return data

func _can_drop_data(_pos, data):
	if  data.origin.node == node or data.origin.isInput == isInput:
		return false
	return true

func reset():
	color = Color.WHITE
	colour = Color.WHITE
	isPluged = false
	isLinked = false
	linked = null

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
		node.updateLogic(index)
	else:
		linked.linkPos = getMiddle(global_position - linked.global_position, size, scale)
		linked.node.updateLogic(linked.index)

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			if (not is_drag_successful() and not isPluged):
				isLinked = false
				queue_redraw()

func updateLink() -> bool:
	if not isPluged:
		return false
	
	var state : bool
	if isInput:
		state = linked.node.updateLogic(linked.index)
	else:
		state = node.updateLogic(index)

	if state:
		colour = Color.DARK_GREEN
		linked.colour = Color.DARK_GREEN
		color = Color.DARK_GREEN
		linked.color = Color.DARK_GREEN
	else:
		colour = Color.DARK_RED
		linked.colour = Color.DARK_RED
		color = Color.DARK_RED
		linked.color = Color.DARK_RED
	queue_redraw()
	return state
