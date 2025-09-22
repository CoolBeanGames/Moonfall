extends Node3D

@export var ammount_gained : int = 6

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.data.set_data("bullets",GameManager.data.get_data("bullets",0) + ammount_gained)
		SignalBus.signals.signals["update_gun_ui"].event.emit()
		queue_free()
