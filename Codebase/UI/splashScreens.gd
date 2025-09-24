extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("splash_screens")

func finish():
	SignalBus.fire_signal("splash_screen_finished")
