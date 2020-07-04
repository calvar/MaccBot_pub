extends Node2D

onready var clock = get_node("Clock")
onready var round_timer = get_node("RoundTimer")
onready var macc_bot = get_node("YSort/MACC_bot")

var mal_bot = preload("res://actors/MAL_bot.tscn")

var mal_bots = []

var secs = 0

func _ready():
	macc_bot.connect("collide",self,"_on_MACC_bot_collide")
	if round_timer.is_stopped():
		round_timer.start()
	clock.start()


func _on_MACC_bot_collide():
	macc_bot.explode()


func _on_RoundTimer_timeout():
	macc_bot.game_turn += 1 
	#print("NEXT ROUND")


func _on_Clock_timeout():
	secs += 1
	print("time: ",secs)
