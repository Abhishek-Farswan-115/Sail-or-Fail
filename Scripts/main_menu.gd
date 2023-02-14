extends Control

@export var Credit_scene: PackedScene
@export var loading_scene: PackedScene


func _on_start_button_button_up():
	get_tree().change_scene_to_packed(loading_scene)

func _on_credit_button_button_up():
	get_tree().change_scene_to_packed(Credit_scene)

func _on_quit_button_pressed():
	get_tree().quit()
