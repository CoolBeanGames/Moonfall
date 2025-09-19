##base class for all bullets
class_name bullet extends Node3D

#wether or not this bullet has been setup
@export var is_initialized : bool = false
var velocity : Vector3
var time : float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_initialized:
		time -= delta
		if time <= 0:
			queue_free()
		position += velocity * delta


func shoot(direction : Vector3, speed : float, distance : float):
	#look_at(global_position + direction,Vector3.UP)
	print("look at: ", global_position , " + " , direction , " = " , global_position - direction)
	#rotate_x(deg_to_rad(90))
	velocity = direction.normalized() * speed
	print("velocity: ", velocity)
	time = distance/speed
	print("time: ", time)
	is_initialized = true

