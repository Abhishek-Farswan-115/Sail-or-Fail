class_name TerrainController extends Node3D


@export_category("Parameters")
@export var terrain_velocity: float = 12.0
@export var num_terrain_blocks = 5
@export_dir var terrian_blocks_path = "res://Scenes/terrain/terrain_blocks/"

var TerrainBlocks: Array
var terrain_belt: Array[TerrainBlock]
var unready_belt: Array[TerrainBlock]

var noise: FastNoiseLite
var time: float = 0.0

var is_loaded: bool = false
var worker: Thread

func _ready() -> void:
	_load_terrain_scenes(terrian_blocks_path)
	
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_octaves = 8
	noise.fractal_lacunarity = 1.5
	noise.frequency = 0.05
	
	worker = Thread.new()
	
	_init_blocks(num_terrain_blocks)

func _process(_delta: float) -> void:
	if !worker.is_started() and !unready_belt.is_empty():
		worker.start(Callable(self, "worker_load_block").bind([unready_belt[-1], worker]))

func _physics_process(delta: float) -> void:
	_progress_terrain(delta)

func _init_blocks(number_of_blocks: int) -> void:
	_create_block(false, null, true)
	while unready_belt.size() < number_of_blocks:
		var last: TerrainBlock = unready_belt[0]
		_create_block(true, last, false, true if unready_belt.size() + 1 == number_of_blocks else false)

func _progress_terrain(delta: float) -> void:
	if !is_loaded: return
	
	time += delta
	
	for block in terrain_belt:
		block.position.z += terrain_velocity * delta
	for block in unready_belt:
		block.position.z += terrain_velocity * delta
	
	if terrain_belt.is_empty(): return
	
	for i in range(terrain_belt.size()):
		if ! i in range(terrain_belt.size()): break
		if terrain_belt[i].position.z >= terrain_belt[i].size.z*2:
			var first: TerrainBlock = terrain_belt.pop_at(i)
			var last: TerrainBlock = terrain_belt[-1]
			_create_block(true, last)
			first.queue_free()

func _append_to_far_edge(target_block: TerrainBlock, appending_block: TerrainBlock) -> void:
	appending_block.position.z = target_block.position.z - target_block.size.z/2 - appending_block.size.z/2

func _load_terrain_scenes(target_path: String) -> void:
	var dir = DirAccess.open(target_path)
	for scene_path in dir.get_files():
		print("Loading terrian block scene: " + target_path + scene_path)
		TerrainBlocks.append(load(target_path + scene_path))

func _create_block(at_edge: bool, last: TerrainBlock, empty: bool = false, load_finisher: bool = false) -> TerrainBlock:
	var block: TerrainBlock = TerrainBlocks.pick_random().instantiate() if !empty else preload("res://Scenes/terrain/terrain_block_01.tscn").instantiate()
	block.noise = self.noise
	block.load_finisher = load_finisher
	if at_edge: _append_to_far_edge(last, block)
	else: block.position.z = block.size.z / 2
	block.player_relative_position = block.position.z - terrain_velocity * time
	unready_belt.push_front(block)
	return block

func worker_load_block(arr: Array) -> void:
	var block:TerrainBlock = arr[0]
	var thread:Thread = arr[1]
	add_child(block)
	call_deferred("worker_finish_load", block, thread)

func worker_finish_load(block: TerrainBlock, thread:Thread) -> void:
	terrain_belt.append(block)
	var idx: int = unready_belt.find(block)
	if idx >= 0: unready_belt.remove_at(idx)
	if block.load_finisher: 
		get_parent().load_complete.emit()
		is_loaded = true
	thread.wait_to_finish()
