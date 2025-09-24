extends State
class_name GameLoseState

##called once when entering the state and then not again until it has finished
func on_enter():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SceneManager.load_scene(load("res://Scenes/UI_Scenes/game_over_scene.tscn"),"GameOver",true,false)


##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
