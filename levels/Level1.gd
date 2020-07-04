extends "res://levels/Level_template.gd"

func _ready():
	._ready()
	mal_bots.append(mal_bot.instance())
	
	mal_bots[0].id = 0
	mal_bots[0].global_position = Vector2(672,160) #Vector2(672,96)
	mal_bots[0].destination = mal_bots[0].global_position
	mal_bots[0].connect("collide",self,"_on_MAL_bot_collide")
	var main = get_tree().get_root().find_node("YSort",true,false)
	main.add_child(mal_bots[0])

func _on_MAL_bot_collide():
	mal_bots[0].explode()

func _on_RoundTimer_timeout():
	._on_RoundTimer_timeout()
	mal_bots[0].game_turn += 1
