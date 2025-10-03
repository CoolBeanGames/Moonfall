extends Node3D

@export var ammount_gained : int = 6

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.set_data("bullets",GameManager.get_data("bullets",0) + ammount_gained)
		SignalBus.signals.signals["update_gun_ui"].event.emit()
		AudioManager.play_audio_file(load("res://Audio/SFX/item_pickup.wav"),"default",false,Vector3(0,0,0))
		queue_free()
