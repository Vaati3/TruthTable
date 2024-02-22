extends ColorRect

var state:int = 0

func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match state:
			0:
				$inputnode.visible = true
			1:
				$description.visible = true
			2:
				$morenodes.visible = true
			_:
				queue_free()
		state += 1
