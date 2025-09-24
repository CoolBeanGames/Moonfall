extends State
class_name splash_screen_state


##called once when entering the state and then not again until it has finished
func on_enter():
	SceneManager.load_scene(load("res://Scenes/SplashScreens.tscn"),"Splash",false,false)
	print("Parent of Splash: ", SceneManager.active_scenes["Splash"].get_parent().name)

##called when we exit the state
func on_exit():
	pass
