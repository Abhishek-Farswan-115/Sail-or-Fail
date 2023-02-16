extends Control

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _on_quit_button_pressed():
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	get_tree().quit()

func _on_start_button_pressed() -> void:
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	Loader.load_scene(self, "res://Scenes/Game_scene/gameplay.tscn")

func _on_start_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()

func _on_quit_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()
