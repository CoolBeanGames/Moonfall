extends Control

@export var hit_texture : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.signals.signals["hit_enemy"].event.connect(on_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hit_texture.self_modulate = lerp(hit_texture.self_modulate,Color(1,1,1,0),delta)

func on_hit():
	hit_texture.self_modulate = Color(1,1,1,1)
