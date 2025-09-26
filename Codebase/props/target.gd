class_name target extends Node3D

@export var target_ui_scene : PackedScene
@export var free_target : Node

##add this target to the array of all targets automatically
func _ready() -> void:
	if GameManager.data.data.has("targets"):
		GameManager.data.data["targets"].append(self)
	else:
		var target_array : Array[target] = [self]
		GameManager.data.data.set("targets",target_array)

##the target was shot so destroy it
func destroy_target():
	GameManager.data.data.set("destroyed_targets",GameManager.data.data.get("destroyed_targets",0) + 1)
	SceneManager.load_ui_scene(target_ui_scene,"target_ui")
	free_target.queue_free()
