extends "res://levels/Level_template.gd"

onready var mal_bot = get_node("YSort/MAL_bot")

func _ready():
	._ready()
	mal_bot.global_position = Vector2(672,160) #Vector2(672,96)
	mal_bot.destination = mal_bot.global_position
	mal_bot.connect("collide",self,"_on_MAL_bot_collide")

func _on_MAL_bot_collide():
	mal_bot.explode()
