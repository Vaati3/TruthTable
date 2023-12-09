extends Control
class_name TestElement

func init(leveName:String):
	$NameTxt.add_text(leveName)

func updateResult(state:bool):
	if state:
		$TextureRect.texture =  load("res://UI/Icons/circleCheck.svg")
		$StateTxt.clear()
		$StateTxt.modulate = Color.DARK_GREEN
		$StateTxt.add_text("Sucess")
	else:
		$TextureRect.texture =  load("res://UI/Icons/circleCross.svg")
		$StateTxt.clear()
		$StateTxt.modulate = Color.DARK_RED
		$StateTxt.add_text("Failure")
		
