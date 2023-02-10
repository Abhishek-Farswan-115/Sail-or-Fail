class_name TerrainBlock extends Node3D

@export_category("Parameters")
@export var size: Vector3 = Vector3.ONE

@export_category("Decorations")
@export var decoration_amount: int = 10
@export var decoration_scenes: Array[PackedScene]

@onready var editor_nodes: Node3D = $decorations/editor

func _ready() -> void:
	spawn_decoration()
	editor_nodes.visible = false

func spawn_decoration() -> void:
	if decoration_scenes.is_empty(): return
	
	var rate := int(decoration_amount / editor_nodes.get_child_count())	
	for i in editor_nodes.get_children():
		if i is MeshInstance3D and i.mesh is PlaneMesh:
			for j in range(rate):
				var dec: Node3D = decoration_scenes[randi() % decoration_scenes.size()].instantiate()
				$decorations.add_child(dec)
				dec.position = Vector3(randf_range(-i.mesh.size.x/2, i.mesh.size.x/2), 0.0, randf_range(-i.mesh.size.y/2, i.mesh.size.y/2))
				dec.position += i.position
				dec.rotation.y = randf_range(-PI, PI)
