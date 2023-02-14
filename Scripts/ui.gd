class_name UI extends Control

@onready var lives: Label = $lives


func _on_boat_lives_changed(new_lives: int) -> void:
	lives.text = str(new_lives)
