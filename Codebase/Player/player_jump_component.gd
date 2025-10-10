extends Node

@export var move : player_movement
@export var plr : player
@export var delta : float
@export var player_in_air : bool = false
@export var on_floor_sound : AudioStream
@export var jump_sound : AudioStream


func _ready() -> void:
	var action : input_action = InputManager.actions["jump"]
	action.just_released.connect(jump)

func _physics_process(_delta: float) -> void:
	delta = _delta
	if player_in_air and plr.is_on_floor():
		player_in_air = false
		AudioManager.play_audio_file(on_floor_sound,"player_footsteps",false,Vector3(0,0,0))

func jump():
	if plr.is_on_floor():
		print("jump")
		move.y_velocity = plr.bb.data["jump_force"] * delta
		player_in_air = true
		AudioManager.play_audio_file(jump_sound,"player_footsteps",false,Vector3(0,0,0))
