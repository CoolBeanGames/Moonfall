extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ratio : float = float(GameManager.data.data.get("player_health",1)) / float(GameManager.data.data.get("player_max_health", 5))
	material.set_shader_parameter("progress",ratio)
