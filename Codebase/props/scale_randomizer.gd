class_name scale_randomizer extends Node3D

#the object to scale
@export var scale_target : Node3D
#the minimum size the object can be
@export var scale_value_min : float = 0.9
#the max size the object can be
@export var scale_value_max : float = 1.1

##scale a target obejct to the range
func _ready() -> void:
	if scale_target == null:
		scale_target = self
	var scale_float : float = randf_range(scale_value_min,scale_value_max)
	var scale_value : Vector3 = Vector3(scale_float,scale_float,scale_float)
	scale_target.scale = scale_value
