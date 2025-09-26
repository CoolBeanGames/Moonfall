class_name rotation_randomizer extends Node3D

##the object we want to rotate
@export var target : Node3D

##rotate a target to a random angle
func _ready() -> void:
	if target == null:
		target = self
	target.rotate_y(randf_range(-360,360))
