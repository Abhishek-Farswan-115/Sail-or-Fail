class_name Main extends Node

var use_sound: bool = true:
	set(val):
		use_sound = val
		AudioServer.set_bus_mute(0, !val)

var use_vibration: bool = true

func _ready() -> void:
	var save_settings :Settings = Saver.load_res("./settings.tres")
	if save_settings:
		use_sound = save_settings.use_sound
		use_vibration = save_settings.use_vibration
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	get_tree().set_auto_accept_quit(false)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var save_settings = Settings.new()
		save_settings.use_sound = self.use_sound
		save_settings.use_vibration = self.use_vibration
		Saver.save_res(save_settings, "./settings.tres")
		get_tree().quit()
