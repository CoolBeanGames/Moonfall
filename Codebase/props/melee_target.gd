class_name melee_target extends Node3D

@export var parent : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func melee_damage():
	if parent.has_method("melee_damage"):
		parent.melee_damage()
	else:
		push_warning("warning: attempted to do melee damage but the object is missing a valid method")
	pass
