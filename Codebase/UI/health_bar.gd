extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var ratio : float = float(GameManager.get_data("player_health",1)) / float(GameManager.get_data("player_max_health", 5))
	material.set_shader_parameter("progress",ratio)
