extends State
class_name splash_screen_state


##called once when entering the state and then not again until it has finished
func on_enter():
	SceneManager.load_scene(load("res://Scenes/SplashScreens.tscn"),"Splash",false,false)
	print("Parent of Splash: ", SceneManager.active_scenes["Splash"].get_parent().name)
	await SceneManager.get_tree().process_frame
	SignalBus.fire_signal("splash_screen_finished")
	print("splash_screen")
	pass

##called when we exit the state
func on_exit():
	SceneManager.unload_scene("Splash")
	pass

##called every frame for this state
func tick():
	pass
