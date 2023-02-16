extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var Resume: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var MainMenu: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton
@onready var Quit: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	Resume.pressed.connect(unpause)

func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
