class_name crate_piece extends RigidBody3D

@export var t : Timer

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
