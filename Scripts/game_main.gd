class_name GameMain extends Node3D

signal load_complete

func _on_boat_lives_lost() -> void:
	get_tree().reload_current_scene()
