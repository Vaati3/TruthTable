extends Panel

@export var targetPos : Vector2 = Vector2.ZERO
@export var direction : Vector2 = Vector2(0, 1)
@export var speed : int = 7
var originPos : Vector2

var buttonSize : Vector2 = Vector2(120, 60)
@export var buttonPos : Vector2 = Vector2(300, -60)
@export var buttonRotation : float = 0

var isSliderOut : bool = false
var sliderMoving : bool = false

func _ready():
	originPos = position
	$SliderButton.size = buttonSize
	$SliderButton.position = buttonPos
	$SliderButton.rotation = buttonRotation

func _process(delta):
	if sliderMoving:
		if isSliderOut:
			position += direction * speed
			if position.distance_to(targetPos) < speed:
				position = targetPos
				sliderMoving = false
		else:
			position -= direction * speed
			if position.distance_to(originPos) < speed:
				position = originPos
				sliderMoving = false

func reset():
	position = originPos
	sliderMoving = false
	isSliderOut = false

func _on_slider_button_pressed():
	$Audio.play(0.24)
	sliderMoving = true
	isSliderOut = not isSliderOut
