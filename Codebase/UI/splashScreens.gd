extends Node2D
var confirm_action : input_action
var anim : AnimationPlayer
@export var second_splash_time : float = 2.23
@export var end_time : float = 4.33


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim = $AnimationPlayer
	anim.play("splash_screens")
	confirm_action = InputManager.actions["confirm"]
	confirm_action.just_released.connect(skip_first_splash)

func finish():
	SignalBus.fire_signal("splash_screen_finished")

func skip_first_splash():
	confirm_action.just_released.connect(skip_second_splash)
	confirm_action.just_released.disconnect(skip_first_splash)
	anim.seek(second_splash_time)

func skip_second_splash():
	confirm_action.just_released.disconnect(skip_second_splash)
	anim.seek(end_time)
