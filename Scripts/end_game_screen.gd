class_name EndGameScreen extends Control

var coins: int = 0

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	set_coins(coins)

func set_coins(new_coins: int) -> void:
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer/coins.text = str(new_coins)
	
	if coins > get_tree().current_scene.highscore:
		get_tree().current_scene.highscore = coins
	
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/MarginContainer2/HBoxContainer/highscore.text = str(get_tree().current_scene.highscore)

func _on_menu_button_pressed() -> void:
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	get_tree().current_scene.save_game()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_retry_button_pressed() -> void:
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	Loader.load_scene(get_parent().get_parent(), "res://Scenes/Game_scene/gameplay.tscn")

func _on_menu_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()

func _on_retry_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()
