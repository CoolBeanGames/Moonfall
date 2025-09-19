extends State
class_name GamePreloadState

##called once when entering the state and then not again until it has finished
func on_enter():
	SceneManager.load_scene(load("res://Scenes/LoadingScene.tscn"),"Loading",false,false)
	GameManager.data.load_from_json("config.json")
	await SceneManager.get_tree().process_frame
	SignalBus.fire_signal("loading_finished")

##called when we exit the state
func on_exit():
	SceneManager.unload_scene("Loading")
	pass

##called every frame for this state
func tick():
	pass
