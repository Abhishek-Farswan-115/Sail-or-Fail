extends Control

@export var Credit_scene: PackedScene
@export var loading_scene: PackedScene

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed() -> void:
	Loader.load_scene(self, "res://Scenes/Game_scene/gameplay.tscn")
