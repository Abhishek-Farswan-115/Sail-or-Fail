class_name UI extends Control

func _on_boat_lives_changed(new_lives: int) -> void:
	$lives.text = str(new_lives)

func _on_boat_coins_changed(new_coins) -> void:
	$coins.text = str(new_coins)

func _on_boat_lives_lost() -> void:
	for c in get_children(): c.queue_free()
	
	var endgame := preload("res://Scenes/UI/end_game_screen.tscn").instantiate()
	endgame.coins = $"../boat".coins
	add_child(endgame)
