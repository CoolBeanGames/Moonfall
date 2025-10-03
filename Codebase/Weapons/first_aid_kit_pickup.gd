extends Node3D

@export var ammount_healed : float

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player_max_health = GameManager.get_data("player_max_health",1)
		var player_health = GameManager.get_data("player_health",1)
		var original_health = player_health
		player_health *= clamp(ammount_healed,0.0,1.0)
		GameManager.set_data("player_health",clamp(player_health + original_health,0,player_max_health))
		AudioManager.play_audio_file(load("res://Audio/SFX/item_pickup.wav"),"default",false,Vector3(0,0,0))
		AudioManager.play_audio_file(load("res://Audio/SFX/heal.wav"),"default",false,Vector3(0,0,0))
		queue_free()
