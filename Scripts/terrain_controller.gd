class_name TerrainController extends Node3D

var TerrainBlocks: Array = []
var terrain_belt: Array[TerrainBlock] = []
@export var terrain_velocity: float = 12.0
@export var num_terrain_blocks = 5
@export_dir var terrian_blocks_path = "res://Scenes/terrain/terrain_blocks/"

func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	_init_blocks(num_terrain_blocks)

func _physics_process(delta: float) -> void:
	_progress_terrain(delta)

func _init_blocks(number_of_blocks: int) -> void:
	for block_index in number_of_blocks:
		var block = TerrainBlocks.pick_random().instantiate()
		if block_index == 0:
			block.position.z = block.size.z / 2
		else:
			_append_to_far_edge(terrain_belt[block_index-1], block)
		add_child(block)
		terrain_belt.append(block)

func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta

	if terrain_belt[0].position.z >= terrain_belt[0].size.z*2:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()

		var block = TerrainBlocks.pick_random().instantiate()
		_append_to_far_edge(last_terrain, block)
		add_child(block)
		terrain_belt.append(block)
		first_terrain.queue_free()

func _append_to_far_edge(target_block: TerrainBlock, appending_block: TerrainBlock) -> void:
	appending_block.position.z = target_block.position.z - target_block.size.z/2 - appending_block.size.z/2

func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + scene_path)
		TerrainBlocks.append(load(target_path + scene_path))