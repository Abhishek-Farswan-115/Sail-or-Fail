extends Control

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound

func _on_main_menu_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()

func _on_quit_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()

func _on_main_menu_button_pressed() -> void:
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
