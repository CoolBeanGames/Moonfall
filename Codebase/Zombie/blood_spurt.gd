extends Node3D

@export var particle : GPUParticles3D
@export var timer : Timer
@export var emission_ammounts : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var density = GameManager.settings_data.get("particle_density")
	if density == -1:
		queue_free()
		return
	particle.amount = emission_ammounts[clamp(density-1,0,emission_ammounts.size()-1)]
	particle.emitting=true
	timer.start()
	timer.timeout.connect(time_up)


func time_up():
	queue_free()
