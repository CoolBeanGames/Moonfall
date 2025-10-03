class_name player_movement extends Node

@export var plr : player
@export var move_axis : input_axis
@export var sprint_action : input_action
var move_speed : float
var axis_value : Vector2
var lerp_speed : float
var target_velocity : Vector3
var y_velocity : float = 0
var gravity : float = -9.8

func _ready():
	move_axis = InputManager.axis["wasd"]
	sprint_action = InputManager.actions["sprint"]
	
func setup():
	move_axis.context_fired.connect(on_move)
	sprint_action.just_pressed.connect(start_sprint)
	sprint_action.just_released.connect(stop_sprint)
	stop_sprint()


func unset():
	move_axis.context_fired.disconnect(on_move)
	sprint_action.just_pressed.disconnect(start_sprint)
	sprint_action.just_released.disconnect(stop_sprint)

func _physics_process(_delta: float) -> void:
	if !InputManager.is_input_locked():
		axis_value = move_axis.context.get_axis_value()
		lerp_move(_delta)
		plr.move_and_slide()
		target_velocity = Vector3(0,0,0)

func on_move(value : Vector2):
	var forward = -plr.basis.z * (value.y * move_speed )
	var side = plr.basis.x * (value.x * move_speed)
	target_velocity = forward + side

func lerp_move(delta : float):
	lerp_speed = plr.bb.get_data("move_lerp_speed")
	plr.velocity = plr.velocity.lerp(target_velocity,(1-exp(-delta * lerp_speed)))
	apply_gravity(delta)
	plr.velocity.y = y_velocity
	
func apply_gravity(delta : float):
	y_velocity += GameManager.get_data("gravity",0) * delta

func start_sprint():
	move_speed = plr.bb.get_data("run_speed")

func stop_sprint():
	move_speed = plr.bb.get_data("walk_speed")
	
