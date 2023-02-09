extends Node3D
# just some general class, to be executed on the root node

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	if Input.is_action_just_pressed("mouse_capture"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED: DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		else: DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
