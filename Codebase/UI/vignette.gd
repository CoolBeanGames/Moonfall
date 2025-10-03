extends ColorRect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var health     : float = float(GameManager.get_data("player_health", 1))
	var max_health : float = float(GameManager.get_data("player_max_health", 5))
	var ratio      : float = health / max_health

	# Remap so 0.5 -> 0 and 1.0 -> 1
	var mapped : float = clamp((0.5 - ratio) / 0.5, 0.0, 1.0)
	material.set_shader_parameter("radius", mapped)
