extends Node3D

@export var animation : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = $AnimationPlayer
	animation.play("intro animation")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func load_game():
	#GameManager.save_data.data.set("intro_seen",true)
	#GameManager.save_game()
	SignalBus.fire_signal("start_game")
