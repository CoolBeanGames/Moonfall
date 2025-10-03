class_name crate_piece extends RigidBody3D

@export var t : Timer

func _ready() -> void:
	var dir := Vector3(
				randf_range(-1.0, 1.0),
				randf_range(0.5, 1.5), # bias upward so they fly up
				randf_range(-1.0, 1.0)
			).normalized()

			# Random strength
	var strength := randf_range(GameManager.get_data("crate_min_force"), GameManager.get_data("crate_max_force"))
	
	apply_impulse(dir * strength)

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
