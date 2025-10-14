class_name player_movement extends Node

enum stamina_state{critial,draining,filling,full}

@export var plr : player
@export var move_axis : input_axis
@export var sprint_action : input_action
var move_speed : float
var axis_value : Vector2
var lerp_speed : float
var target_velocity : Vector3
var y_velocity : float = 0
var gravity : float = -9.8
var stamina : float = 1
var sprint_state : stamina_state = stamina_state.full
var stamina_bar_visible : bool = false
var player_sprinting : bool = false

@export var view_camera : Camera3D
@export var sprint_sound : AudioStreamPlayer
@export var sprint_speed_minimum : float = 8

func _ready():
	move_axis = InputManager.axis["wasd"]
	sprint_action = InputManager.actions["sprint"]
	GameManager.set_data("player_move",self)
	set_process(true)

func _process(delta: float) -> void:
	update_stamina(delta)

func setup():
	#print("[Debug Hunt] player movement setup")
	InputManager.connect_to_axis("wasd",on_move)
	InputManager.connect_to_axis("move_stick",on_move)
	InputManager.connect_to_action_just_pressed("sprint",start_sprint)
	InputManager.connect_to_action_just_released("sprint",stop_sprint)
	stop_sprint()

func unset():
	#print("[Debug Hunt] player movement unsetup")
	InputManager.disconnect_to_axis("wasd",on_move)
	InputManager.disconnect_to_axis("move_stick",on_move)
	InputManager.disconnect_to_action_just_pressed("sprint",start_sprint)
	InputManager.disconnect_to_action_just_released("sprint",stop_sprint)

func _physics_process(_delta: float) -> void:
	if !InputManager.is_input_locked():
		axis_value = move_axis.context.get_axis_value()
		lerp_move(_delta)
		plr.move_and_slide()
		target_velocity = Vector3(0,0,0)
	print("[Sprint State] state: ", str(sprint_state))

func on_move(value : Vector2):
	if value.y < 0:
		value.y *= 0.8
	var forward = -plr.basis.z * (value.y * move_speed )
	var side =( plr.basis.x * (value.x * move_speed)) * 0.7
	target_velocity = forward + side

func lerp_move(delta : float):
	lerp_speed = plr.bb.get_data("move_lerp_speed") * (2 if player_sprinting else 1)
	plr.velocity = plr.velocity.lerp(target_velocity,(1-exp(-delta * lerp_speed)))
	apply_gravity(delta)
	plr.velocity.y = y_velocity
	
func apply_gravity(delta : float):
	y_velocity += GameManager.get_data("gravity",0) * delta

func start_sprint():
	print("[sprint] start sprint")
	#print("[Debug Hunt] start sprint called")
	if sprint_state != stamina_state.critial:
		move_speed = plr.bb.get_data("run_speed")
		sprint_state = stamina_state.draining
		player_sprinting = true
	else:
		move_speed = plr.bb.get_data("walk_speed")
		player_sprinting = false

func stop_sprint():
	print("[Debug Hunt] stop sprint called")
	move_speed = plr.bb.get_data("walk_speed")
	player_sprinting = false
	if sprint_state != stamina_state.critial:
		sprint_state = stamina_state.filling

func update_stamina(delta):
	var s_bar = GameManager.get_data("stamina_display")
	var s_disp = s_bar as stamina_display
	
	if stamina <= 0:
		sprint_state = stamina_state.critial
		stop_sprint()
		if s_disp and !stamina_bar_visible:
			s_disp.show_bar()
			
	var drain_rate = 1/plr.bb.get_data("sprint_time")
	var fill_rate = 1/plr.bb.get_data("refill_time")
	var fill_rate_empty = 1/plr.bb.get_data("refill_time_empty")
	
	print("[Sprint Drain] Draing Rate : " ,drain_rate," Stamina " , stamina)
	
	if sprint_state == stamina_state.draining:
		stamina -= delta * drain_rate
		if s_disp and !stamina_bar_visible:
			s_disp.show_bar()
	if sprint_state == stamina_state.filling:
		stamina += delta * fill_rate
		if s_disp and !stamina_bar_visible:
			s_disp.show_bar()
		if stamina >=1:
			stamina = 1
			sprint_state = stamina_state.full
		if s_disp and stamina_bar_visible:
			s_disp.hide_bar()
	if sprint_state == stamina_state.critial:
		stamina += delta * fill_rate_empty
		if stamina >=1:
			stamina = 1
			sprint_state = stamina_state.full
			if s_disp and !stamina_bar_visible:
				s_disp.hide_bar()
	
	GameManager.set_data("player_stamina",stamina)
