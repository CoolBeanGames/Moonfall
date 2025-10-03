extends MeshInstance3D

func _ready() -> void:
	SignalBus.connect_signal("update_lod",update_LOD)
	update_LOD()

func free() -> void:
	SignalBus.disconnect_signal("update_lod",update_LOD)

func update_LOD():
	lod_bias = GameManager.get_data("LOD_presets")[GameManager.get_setting("graphics_level")]
