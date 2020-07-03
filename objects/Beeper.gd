extends Area2D

onready var animation = get_node("Sprite/AnimationPlayer")

var type = "none"
var activated = true

func _process(delta):
	if activated:
		animation.play("on")
	else:
		animation.play("off")
