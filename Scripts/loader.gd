extends Node

const LOADING_SCENE: String = "res://Scenes/UI/loading_scene.tscn"

var loading_scene_inst: Node

func load_scene(current_scene:Node, next_scene:String) -> void:
	loading_scene_inst = preload(LOADING_SCENE).instantiate()
	get_tree().current_scene.add_child(loading_scene_inst)
	
	await get_tree().create_timer(0.1).timeout
	current_scene.queue_free()
	
	var scn = load(next_scene).instantiate()
	get_tree().current_scene.add_child(scn)
	scn.load_complete.connect(Callable(self, "_on_level_finished_load"))
	return

func _on_level_finished_load() -> void:
	if loading_scene_inst:
		loading_scene_inst.queue_free()
