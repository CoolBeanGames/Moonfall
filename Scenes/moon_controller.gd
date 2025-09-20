extends Node3D

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	GameManager.data.set_data("moon",self)

func moon_fall_finished():
	print("moon has fallen")
	pass
