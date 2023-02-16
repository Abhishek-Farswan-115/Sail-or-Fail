extends Node

const LOADING_SCENE: String = "res://Scenes/UI/loading_scene.tscn"

var loading_scene_inst: Node

func load_scene(current_scene:Node, next_scene:String) -> void:
	loading_scene_inst = preload(LOADING_SCENE).instantiate()
	get_tree().current_scene.add_child(loading_scene_inst)
	
	await get_tree().create_timer(0.1).timeout
	
	ResourceLoader.load_threaded_request(next_scene)
	
	current_scene.queue_free()
	var progress := []
	
	while true:
		var status = ResourceLoader.load_threaded_get_status(next_scene, progress)
		loading_scene_inst.update_progress(progress[0])
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			await get_tree().create_timer(0.1).timeout
			var scn = ResourceLoader.load_threaded_get(next_scene).instantiate()
			get_tree().current_scene.add_child(scn)
			
			scn.load_complete.connect(Callable(self, "_on_level_finished_load"))
			return

func _on_level_finished_load() -> void:
	if loading_scene_inst:
		loading_scene_inst.queue_free()
