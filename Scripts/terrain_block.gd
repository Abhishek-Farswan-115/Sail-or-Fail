class_name TerrainBlock extends Node3D

@export_category("Parameters")
@export var size: Vector3 = Vector3.ONE

@export_category("Decorations")
@export var foliage_types: Array[FoliageType]

@onready var editor_nodes: Node3D = $decorations/editor

func _ready() -> void:
	spawn_decoration()
	editor_nodes.visible = false

func spawn_decoration() -> void:
	if foliage_types.is_empty(): return
	
	for fol in foliage_types:
		var rate := int(fol.instance_number / editor_nodes.get_child_count())
		for i in editor_nodes.get_children():
			if i is MeshInstance3D and i.mesh is PlaneMesh:
				for j in range(rate):
					var dec: Node3D = foliage_types[randi() % foliage_types.size()].instance_scene.instantiate()
					$decorations.add_child(dec)
					dec.position = Vector3(randf_range(-i.mesh.size.x/2, i.mesh.size.x/2), 0.0, randf_range(-i.mesh.size.y/2, i.mesh.size.y/2))
					dec.position += i.position
					dec.rotation.y = randf_range(-PI, PI)
