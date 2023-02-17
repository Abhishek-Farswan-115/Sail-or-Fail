class_name TerrainBlock extends Node3D

@export_category("Parameters")
@export var size: Vector3 = Vector3(8.0, 0.0, 43.0)

@export_category("Decorations")
@export var foliage_types: Array[FoliageType]

@onready var editor_nodes: Node3D = $decorations/editor

var noise: FastNoiseLite

var height_magnitude: float = 10.0
var height_offset: float = 4.0

var player_relative_position: float = 0.0

var load_finisher := false

func _ready() -> void:
	editor_nodes.visible = false
	spawn_decoration()
	generate_chunk()

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
					dec.position.y = height_for_position(dec.position.x, dec.position.z + player_relative_position) - 0.5
					dec.rotation.y = randf_range(-PI, PI)

func generate_chunk() -> void:
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size.x*2, size.z)
	plane_mesh.subdivide_depth = size.x * 2.0
	plane_mesh.subdivide_width = size.z * 2.0
	
	# TODO give a material
	
	var surface_tool = SurfaceTool.new()
	var data_tool = MeshDataTool.new()
	
	surface_tool.create_from(plane_mesh, 0)
	var array_plane := surface_tool.commit()
	var _error := data_tool.create_from_surface(array_plane, 0)
	
	for i in range(data_tool.get_vertex_count()):
		var vertex := data_tool.get_vertex(i)
		vertex.y = height_for_position(vertex.x + position.x, vertex.z + player_relative_position)
		data_tool.set_vertex(i, vertex)
	
	array_plane.clear_surfaces()
	
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	surface_tool.generate_tangents()
	
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.material_override = preload("res://Scenes/terrain/shaders/terrain_material.tres")
	add_child(mesh_instance)

func height_for_position(x: float, z: float) -> float:
	var h: float
	h = (noise.get_noise_2d(x, z) * height_magnitude) + height_offset
	h = h * smoothstep(0.2, 1.0, abs(x / 14.0))
	h -= 1.0 - smoothstep(0.2, 1.0, abs(x / 5.0))
	return h
