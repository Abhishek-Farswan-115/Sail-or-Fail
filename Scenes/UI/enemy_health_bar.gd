extends TextureProgressBar

var bar_red = preload("res://Scenes/UI/barHorizontal_red_mid 200.png")
var bar_green = preload("res://Scenes/UI/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://Scenes/UI/barHorizontal_yellow_mid 200.png")


func _ready():
	hide()


func _on_value_changed(p_value: float) -> void:
	value = p_value
	if value < max_value:
		show()
	texture_progress = bar_green
	if value < 0.75 * max_value:
		texture_progress = bar_yellow
	if value < 0.45 * max_value:
		texture_progress = bar_red
