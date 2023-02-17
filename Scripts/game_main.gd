class_name GameMain extends Node3D

signal load_complete

func _on_boat_lives_lost() -> void:
	$terrain_controller.is_loaded = false

func pause_game(new_pause: bool = true) -> void:
	$terrain_controller.is_loaded = !new_pause
	$boat.can_move = !new_pause
