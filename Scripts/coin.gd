class_name Coin extends Area3D

var time :float = 0.0

func _process(delta: float) -> void:
	time += delta
	$mesh.position.y = sin(time * 120.0 * delta) * 0.3 + 0.2
	$mesh.rotation.y += delta * 10.0
