extends Node3D

@export var timer : float
@export var moon_fall_time : float

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	GameManager.data.set_data("moon",self)

func moon_fall_finished():
	print("moon has fallen")
	pass

func _process(delta: float) -> void:
	timer += delta
	var ratio = timer / moon_fall_time
	GameManager.data._set("time_ratio",ratio)
