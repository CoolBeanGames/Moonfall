extends Node3D
var confirm_action : input_action
@export var end_time : float = 4.33
@export var animation : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = $AnimationPlayer
	GameManager.save_data.data.set("intro_seen",true)
	GameManager.save_game()
	animation.play("intro animation")	
	confirm_action = InputManager.actions["confirm"]
	confirm_action.just_released.connect(skip_intro)

func load_game():
	SignalBus.fire_signal("start_game")

func skip_intro():
	animation.seek(end_time)
	confirm_action.just_released.disconnect(skip_intro)
