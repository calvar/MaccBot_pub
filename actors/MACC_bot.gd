extends "res://actors/Bot.gd"

signal moved

func _ready():
	read_file()
	facing = orientation['right']
	global_position = Vector2(32,544)
	destination = global_position
	#animation.play("idle-r")

#func _physics_process(delta):
#	._physics_process(delta)
	#print(instructions)

func read_file():
	var file = File.new() 
	file.open("res://assets/instructions2.json", file.READ)
	var text = file.get_as_text()
	instructions = parse_json(text)
	file.close()

func action():
	.action() #calls move function of parent class
	if instruction == "move":
		emit_signal("moved")

"""
func move():
	.move() #calls move function of parent class
	emit_signal("moved")
"""
