extends State
class_name title_screen_state

##called once when entering the state and then not again until it has finished
func on_enter():
	print("title")	
	SceneManager.load_scene(load("res://Scenes/TitleScene.tscn"),"Title",false,false)
	await SceneManager.get_tree().process_frame
	pass

##called when we exit the state
func on_exit():
	SceneManager.unload_scene("Title")
	pass

##called every frame for this state
func tick():
	pass
