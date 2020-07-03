extends KinematicBody2D


onready var sprite = get_node("Sprite")
onready var animation = get_node("Sprite/AnimationPlayer")
onready var animationTree = get_node("Sprite/AnimationTree")
onready var animationState = animationTree.get("parameters/playback")
onready var ray_up = get_node("RayUp")
onready var ray_down = get_node("RayDown")
onready var ray_right = get_node("RayRight")
onready var ray_left = get_node("RayLeft")
onready var idle_timer = get_node("IdleTimer")
onready var pick_timer = get_node("PickTimer")


var orientation = {'up': Vector2(0,-1),
	'down': Vector2(0,1),
	'right': Vector2(1,0),
	'left': Vector2(-1,0)}

enum {IDLE,
	MOVE,
	TURN,
	PICK,
	DEAD}
var state = IDLE

const SPEED = 50
const STEP = 64
const POSITION_ERROR = 1
var velocity = Vector2(0,0)
var destination = global_position
var facing = orientation['right']

var over_beeper = false

var instructions = []
var instruction

signal collide


func _physics_process(delta):
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state()
		TURN:
			turn_state()
		PICK:
			pick_state()
		DEAD:
			pass
	velocity = move_and_slide(velocity)


func action():
	instruction = read_instruction()
	#if instruction != "none": print(instruction)
	if instruction == "move":
		state = MOVE
	elif instruction == "turn_left":
		state = TURN
	elif instruction == "pick_beeper":
		state = PICK

func read_instruction():
	var instruction = "pick_beeper" if state == PICK else "none"
	if state == IDLE and instructions.size() > 0:
		instruction = instructions[0]
		instructions.pop_front()
	return instruction


func correct_position():
	if int(global_position.x) % 32 != 0:
		global_position.x += POSITION_ERROR*facing.x
	if int(global_position.y) % 32 != 0:
		global_position.y += POSITION_ERROR*facing.y
	global_position = Vector2(int(global_position.x), int(global_position.y))
	#print("gp: ",global_position)

func compute_destination():
	destination = global_position + STEP*Vector2(facing.x, facing.y)

func move_state():
	#print("into move state")
	if global_position.distance_to(destination) < POSITION_ERROR:
		#Compute the new destination
		correct_position()
		compute_destination()
		state = IDLE
	else:
		velocity = facing * SPEED
		animationTree.set("parameters/walk/blend_position",facing)
		animationState.travel("walk")
		
		var c1 = facing == orientation['right'] and not ray_right.is_colliding()
		var c2 = facing == orientation['up'] and not ray_up.is_colliding()
		var c3 = facing == orientation['left'] and not ray_left.is_colliding()
		var c4 = facing == orientation['down'] and not ray_down.is_colliding()
		if not c1 and not c2 and not c3 and not c4:
			print("can't go through wall")
			emit_signal("collide")



func turn_state():
	#print("into turn state")
	velocity = Vector2(0,0)
	if facing == orientation['right']:
		facing = orientation['up']
	elif facing == orientation['up']:
		facing = orientation['left']
	elif facing == orientation['left']:
		facing = orientation['down']
	elif facing == orientation['down']:
		facing = orientation['right']
		
	animationTree.set("parameters/idle/blend_position",facing)
	animationState.travel("idle")
	compute_destination()
	state = IDLE


func idle_state():
	#print("into idle state")
	velocity = Vector2(0,0)
	animationTree.set("parameters/idle/blend_position",facing)
	animationState.travel("idle")
	if idle_timer.is_stopped():
		idle_timer.start()



func pick_state():
	#print("into pick state")
	velocity = Vector2(0,0)
	animationTree.set("parameters/idle/blend_position",facing)
	animationState.travel("pick")
	if pick_timer.is_stopped():
		pick_timer.start()

"""
func turn_off():
	velocity = Vector2(0,0)
	instructions.clear()
	animationTree.set("parameters/idle/blend_position",facing)
	animationState.travel("idle")
	#print("Turned off")
"""

func explode():
	velocity = Vector2(0,0)
	instructions.clear()
	animationTree.set("parameters/explode/blend_position",facing)
	animationState.travel("explode")
	state = DEAD


func _on_IdleTimer_timeout():
	action()
	#print("STOP")


func _on_PickTimer_timeout():
	action()


func _on_detectBeeperArea_area_entered(area):
	if "Beeper" in area.name:
		print("over beeper")
		over_beeper = true


