extends Node

@export var move : player_movement
@export var plr : player
@export var delta : float


func _ready() -> void:
	var action : input_action = InputManager.actions["jump"]
	action.just_released.connect(jump)

func _physics_process(_delta: float) -> void:
	delta = _delta

func jump():
	if plr.is_on_floor():
		print("jump")
		move.y_velocity = plr.bb.data["jump_force"] * delta
