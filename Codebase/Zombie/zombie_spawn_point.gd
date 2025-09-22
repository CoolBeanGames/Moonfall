class_name zombie_spawn_point extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.zombie_spawners.append(self)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.zombie_spawners.erase(self)
