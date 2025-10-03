extends Node3D

@export var timer : float
@export var moon_fall_time : float
@export var moon_animator : AnimationPlayer

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	GameManager.set_data("moon",self)

func moon_fall_finished():
	print("moon has fallen")
	SignalBus.fire_signal("player_killed")
	pass

func _process(delta: float) -> void:
	timer += delta
	var ratio = timer / moon_fall_time
	GameManager.set_data("time_ratio",ratio)

func moon_anim_playing():
	print("playing moon animation")
