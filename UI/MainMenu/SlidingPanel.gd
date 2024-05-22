extends Panel

@export var isTop : bool = true
@export var speed : int = 7
#@export var buttonSize : Vector2 = Vector2(120, 60)
var direction : Vector2 = Vector2(0, -1)
var originPos : Vector2

var isSliderOut : bool = false
var sliderMoving : bool = false

func _ready():
	originPos = position
	if not isTop:
		$SliderButton.rotation_degrees = 180;
		$SliderButton.position = Vector2(size.x / 2 - $SliderButton.size.x / 2, size.y);
		direction = Vector2(0, 1);
	get_tree().get_root().size_changed.connect(resize)

func resize():
	if sliderMoving:
		reset()
	elif isSliderOut:
		originPos = position -  size * direction
	else:
		originPos = position

func _process(_delta):
	if sliderMoving:
		if isSliderOut:
			position += direction * speed
			var targetPos = size * direction + originPos
			if position.distance_to(targetPos) < speed:
				position = targetPos
				sliderMoving = false
		else:
			position -= direction * speed
			if position.distance_to(originPos) < speed:
				position = originPos
				sliderMoving = false

func reset():#
	position = originPos
	sliderMoving = false
	isSliderOut = false

func _on_slider_button_pressed():
	$Audio.play(0.24)
	sliderMoving = true
	isSliderOut = not isSliderOut
