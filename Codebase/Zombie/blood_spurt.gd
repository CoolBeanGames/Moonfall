extends Node3D

@export var particle : GPUParticles3D
@export var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particle.emitting=true
	timer.start()
	timer.timeout.connect(time_up)


func time_up():
	queue_free()
