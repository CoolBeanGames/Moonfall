extends State
class_name GameState

##called once when entering the state and then not again until it has finished
func on_enter():
	GameManager.data._set("score",0)
	SceneManager.load_scene(load("res://Scenes/GameScene.tscn"),"game",true)
	pass

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
