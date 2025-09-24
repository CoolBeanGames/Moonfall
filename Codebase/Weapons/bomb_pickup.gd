extends Node3D

@onready var explosion : PackedScene = preload("res://Scenes/Props/bomb_explosion.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var instance = explosion.instantiate()
		SceneManager.active_scenes[SceneManager.active_scenes.keys()[0]].add_child(instance)
		instance.global_position = global_position
		queue_free()
