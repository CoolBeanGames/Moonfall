class_name GameCreditsState extends State

##called once when entering the state and then not again until it has finished
func on_enter():
	SceneManager.load_scene(load("res://Scenes/UI_Scenes/credits.tscn"),"credits",true,false)

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
