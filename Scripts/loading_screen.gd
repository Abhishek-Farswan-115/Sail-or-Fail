class_name LoadingScreen extends Control

func update_progress(val: float) -> void:
	$VBoxContainer/MarginContainer/ProgressBar.value = val*100.0
