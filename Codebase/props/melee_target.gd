class_name melee_target extends Node3D

@export var parent : Node


func take_damage(damage : int):
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
	else:
		push_warning("warning: attempted to do melee damage but the object is missing a valid method")
	pass
