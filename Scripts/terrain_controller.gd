class_name TerrainController extends Node3D

var TerrainBlocks: Array = []
var terrain_belt: Array[TerrainBlock] = []


@export_category("Parameters")
@export var terrain_velocity: float = 12.0
@export var num_terrain_blocks = 5
@export_dir var terrian_blocks_path = "res://Scenes/terrain/terrain_blocks/"

var noise: FastNoiseLite
var player_relative_position: float = 0.0

var time: float = 0.0

func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = 8
	noise.fractal_lacunarity = 1.5
	noise.frequency = 0.05
	
	_init_blocks(num_terrain_blocks)

func _physics_process(delta: float) -> void:
	_progress_terrain(delta)

func _process(delta: float) -> void:
	time += delta

func _init_blocks(number_of_blocks: int) -> void:
	for block_index in number_of_blocks:
		var last: TerrainBlock
		if block_index != 0:
			last = terrain_belt[block_index-1]
		_create_block(!(block_index == 0), last)

func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta

	if terrain_belt[0].position.z >= terrain_belt[0].size.z*2:
		var last_terrain = terrain_belt[-1]
		var first_terrain = terrain_belt.pop_front()
		
		_create_block(true, last_terrain)
		first_terrain.queue_free()

func _append_to_far_edge(target_block: TerrainBlock, appending_block: TerrainBlock) -> void:
	appending_block.position.z = target_block.position.z - target_block.size.z/2 - appending_block.size.z/2

func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + scene_path)
		TerrainBlocks.append(load(target_path + scene_path))

func _create_block(at_edge: bool, last: TerrainBlock) -> TerrainBlock:
	var block: TerrainBlock = TerrainBlocks.pick_random().instantiate()
	block.noise = self.noise
	if at_edge: _append_to_far_edge(last, block)
	else: block.position.z = block.size.z / 2
	block.player_relative_position = block.position.z - terrain_velocity * time
	add_child(block)
	terrain_belt.append(block)
	return block
