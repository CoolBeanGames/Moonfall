class_name rotation_randomizer extends Node3D

##the object we want to rotate
@export var rotation_target : Node3D

##rotate a target to a random angle
func _ready() -> void:
	if rotation_target == null:
		rotation_target = self
	rotation_target.rotate_y(randf_range(-360,360))
