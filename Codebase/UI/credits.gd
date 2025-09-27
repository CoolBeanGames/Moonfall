extends Node2D

@export var anim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("scroll")

func finish():
	SignalBus.fire_signal("to_title")
