extends Node

func save_res(res: Resource, file: String):
	var result = ResourceSaver.save(res, file)
	assert(result == OK)

func load_res(file: String):
	if ResourceLoader.exists(file):
		var res = ResourceLoader.load(file)
		assert(res is Resource)
		return res
