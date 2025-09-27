extends Node3D

@export var particle : CPUParticles3D
@export var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particle.emitting=true
	timer.start()
	timer.timeout.connect(time_up)
	print("spawned")


func time_up():
	print("destroyed")
	queue_free()
