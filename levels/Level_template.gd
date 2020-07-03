extends Node2D

onready var round_timer = get_node("RoundTimer")
onready var macc_bot = get_node("YSort/MACC_bot")

func _ready():
	macc_bot.connect("collide",self,"_on_MACC_bot_collide")

func _process(delta):
	if round_timer.is_stopped():
		round_timer.start()
		print("START ROUND")

func _on_MACC_bot_collide():
	macc_bot.explode()


func _on_RoundTimer_timeout():
	print("STOP ROUND")
