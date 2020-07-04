extends "res://actors/Bot.gd"

onready var macc_bot = get_node("/root").find_node("MACC_bot",true,false)

const CATCH_RANGE = 4

var id

func _ready():
	facing = orientation['left']
	#animation.play("idle-l")
	macc_bot.connect("moved",self,"_on_MACC_bot_moved")

#func _physics_process(delta):
#	._physics_process(delta)
#	#print(state,instruction,instructions)
#	#print(old_game_turn," ",game_turn)

func set_instructions():
	#print(macc_in_LOS())
	if macc_in_LOS():
		var d = macc_bot.destination - global_position
		#print(d.length())
		if (macc_bot.global_position-global_position).length()-CATCH_RANGE <= STEP:
			#emit_signal("catched")
			macc_bot.explode()
		else:
			var horizontal
			var h_condition = (d.x > 0 and not ray_right.is_colliding()) or  (d.x < 0 and not ray_left.is_colliding())
			var v_condition = (d.y > 0 and not ray_down.is_colliding()) or  (d.y < 0 and not ray_up.is_colliding())
			
			if h_condition and not v_condition:
				horizontal = true
			elif v_condition and not h_condition:
				horizontal = false
			elif abs(d.x) > abs(d.y):
				horizontal = true
			else:
				horizontal = false
			
			if horizontal:
				if d.x > 0:
					go_right()
					#print("r")
				elif d.x < 0:
					go_left()
					#print("l")
			else:
				if d.y > 0:
					go_down()
					#print("d")
				elif d.y < 0:
					go_up()
					#print("u")


func go_up():
	var turns = 0
	if facing == orientation['left']:
		turns = 3
	elif facing == orientation['down']:
		turns = 2
	elif facing == orientation['right']:
		turns = 1
	for _i in range(turns):
		instructions.append("turn_left")
	instructions.append("move")

func go_left():
	var turns = 0
	if facing == orientation['down']:
		turns = 3
	elif facing == orientation['right']:
		turns = 2
	elif facing == orientation['up']:
		turns = 1
	for _i in range(turns):
		instructions.append("turn_left")
	instructions.append("move")

func go_down():
	var turns = 0
	if facing == orientation['right']:
		turns = 3
	elif facing == orientation['up']:
		turns = 2
	elif facing == orientation['left']:
		turns = 1
	for _i in range(turns):
		instructions.append("turn_left")
	instructions.append("move")

func go_right():
	var turns = 0
	if facing == orientation['up']:
		turns = 3
	elif facing == orientation['left']:
		turns = 2
	elif facing == orientation['down']:
		turns = 1
	for _i in range(turns):
		instructions.append("turn_left")
	instructions.append("move")

func macc_in_LOS():
	var space = get_world_2d().direct_space_state
	var obstacle = space.intersect_ray(global_position,macc_bot.global_position,[self],collision_mask)
	#print(obstacle.collider == macc_bot)
	if not obstacle:
		return false
	if obstacle.collider == macc_bot:
		return true
	else:
		return false
	
func _on_MACC_bot_moved():
	#print("macc moved")
	set_instructions()
