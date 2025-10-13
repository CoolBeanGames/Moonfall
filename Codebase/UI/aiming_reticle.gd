extends Control

@export var hit_texture : TextureRect
@export var anima : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect_signal("hit_enemy",on_hit)

func on_hit():
	anima.play("headshot")
	
