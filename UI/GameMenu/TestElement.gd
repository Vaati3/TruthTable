extends Control
class_name TestElement

func init(name:String):
	$NameTxt.add_text(name)

func updateResult(state:bool):
	if state:
		$ColorRect.color = Color.DARK_GREEN
		$StateTxt.clear()
		$StateTxt.add_text("Sucess")
	else:
		$ColorRect.color = Color.DARK_RED
		$StateTxt.clear()
		$StateTxt.add_text("Failure")
