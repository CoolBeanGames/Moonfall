class_name target_destroyed_ui extends Control

@export var display : Label
@export var anim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var targets_destroyed : int = GameManager.data.data.get("destroyed_targets",0)
	var targets : int = GameManager.data.data.get("targets").size()
	display.text = "Target " + str(targets_destroyed) + " of " + str(targets) + " Destroyed"
	anim.play("fade")

func end():
	SceneManager.unload_ui("target_ui")
