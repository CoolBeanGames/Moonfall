class_name target extends Node3D

@export var target_ui_scene : PackedScene
@export var free_target : Node

##add this target to the array of all targets automatically
func _ready() -> void:
	if GameManager.data.data.has("targets"):
		GameManager.data.data["targets"].append(self)
	else:
		var target_array : Array[target] = [self]
		GameManager.set_data("targets",target_array)

##the target was shot so destroy it
func take_damage(_damage : int = 0):
	GameManager.set_data("destroyed_targets",GameManager.get_data("destroyed_targets",0) + 1)
	if GameManager.get_data("destroyed_targets",0) > GameManager.save_data.data.get("destroyed_targets",-1):
		GameManager.save_data.data.set("destroyed_targets",GameManager.get_data("destroyed_targets",0))
		GameManager.save_game()
		print("save game")
	print("did not save game: " , str(GameManager.get_data("destroyed_targets",0) , " / " , str(GameManager.save_data.data.get("destroyed_targets",-1)) , " ? : " , str(GameManager.get_data("destroyed_targets",0) > GameManager.save_data.data.get("destroyed_targets",-1))))
	SceneManager.load_ui_scene(target_ui_scene,"target_ui")
	GameManager.increase_score(5)
	print("score up by 5")
	SignalBus.fire_signal("update_gun_ui")
	free_target.queue_free()
