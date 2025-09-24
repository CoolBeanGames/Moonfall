extends Node

@export var move : player_movement
@export var plr : player
@export var delta : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var action : input_action = InputManager.actions["jump"]
	action.just_released.connect(jump)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	delta = _delta
	pass

func jump():
	if plr.is_on_floor():
		print("jump")
		move.y_velocity = plr.bb.data["jump_force"] * delta
