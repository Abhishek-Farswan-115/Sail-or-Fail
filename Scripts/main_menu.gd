extends Control

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	$boat_bg.position = lerp($boat_bg.position, Vector2(0.0, 0.0), delta * 30.0)
	$env_bg.position = lerp($env_bg.position, Vector2(-50.0, -30.0), delta * 20.0)

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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$boat_bg.position += event.relative * 0.6
		$env_bg.position += event.relative * -0.1
