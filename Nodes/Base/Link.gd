extends Control
class_name Link

var plug: Plug

func _init(parentPlug: Plug):
	plug = parentPlug

func _draw():
	if plug != null && plug.isLinked:
		draw_line(plug.getMiddle(Vector2(0, 0) + plug.global_position, 
			plug.size, plug.scale), plug.linkPos + plug.global_position, 
			plug.lineColour, 10)
