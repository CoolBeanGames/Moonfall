extends Node3D

@export var animation : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = $AnimationPlayer
	GameManager.save_data.data.set("intro_seen",true)
	GameManager.save_game()
	animation.play("intro animation")

func load_game():
	SignalBus.fire_signal("start_game")
