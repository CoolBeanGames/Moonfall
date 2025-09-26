##strategy that detonates a bomb
class_name bomb_strategy extends strategy

##call to detonate a bomb
func execute(...params : Array):
	var instance = load("res://Scenes/Props/bomb_explosion.tscn").instantiate()
	SceneManager.active_scenes[SceneManager.active_scenes.keys()[0]].add_child(instance)
	instance.global_position = params[0]
