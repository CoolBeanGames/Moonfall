class_name melee_target extends Node3D

@export var parent : Node


func melee_damage():
	if parent.has_method("melee_damage"):
		parent.melee_damage()
	else:
		push_warning("warning: attempted to do melee damage but the object is missing a valid method")
	pass
