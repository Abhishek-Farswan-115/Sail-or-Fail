class_name UI extends Control

@export var pause_menu_scene: PackedScene = preload("res://Scenes/UI/pause_screen.tscn")

var pause_menu: Control = null
var has_lost: bool = false

func _on_boat_lives_changed(new_lives: int) -> void:
	$HBoxContainer2/lives.text = str(new_lives)

func _on_boat_coins_changed(new_coins) -> void:
	$HBoxContainer/coins.text = str(new_coins)

func _on_boat_lives_lost() -> void:
	for c in get_children(): c.queue_free()
	
	var endgame := preload("res://Scenes/UI/end_game_screen.tscn").instantiate()
	endgame.coins = $"../boat".coins
	add_child(endgame)
	
	has_lost = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if pause_menu != null:
			pause_menu.queue_free()
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
			get_parent().pause_game(false)
		elif !has_lost:
			pause_menu = pause_menu_scene.instantiate()
			add_child(pause_menu)
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
			get_parent().pause_game()
