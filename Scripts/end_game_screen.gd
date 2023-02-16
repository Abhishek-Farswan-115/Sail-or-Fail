class_name EndGameScreen extends Control

var coins: int = 0

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	set_coins(coins)

func set_coins(new_coins: int) -> void:
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/coins.text = str(new_coins) + " COINS"

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_retry_button_pressed() -> void:
	Loader.load_scene(get_parent().get_parent(), "res://Scenes/Game_scene/gameplay.tscn")
