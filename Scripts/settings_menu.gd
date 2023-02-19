class_name SettingsMenu extends Control

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound

func _ready() -> void:
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer3/sound.button_pressed = get_tree().current_scene.use_sound
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer4/vib.button_pressed = get_tree().current_scene.use_vibration

func _on_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()

func _on_back_pressed() -> void:
	clicked_sound.play()
	await get_tree().create_timer(0.27).timeout
	queue_free()

func _on_sound_toggled(button_pressed: bool) -> void:
	clicked_sound.play()
	get_tree().current_scene.use_sound = button_pressed

func _on_vib_toggled(button_pressed: bool) -> void:
	clicked_sound.play()
	get_tree().current_scene.use_vibration = button_pressed
