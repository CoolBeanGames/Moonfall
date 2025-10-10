class_name ejected_bullet extends Node3D

@export var rigidbody : RigidBody3D
@export var ejection_force : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rigidbody.apply_impulse(ejection_force)
	rigidbody.apply_torque(Vector3(0,1.5,0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
