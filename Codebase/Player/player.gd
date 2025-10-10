##base class for the player manager
class_name player extends CharacterBody3D

#blackboard for holding all character specific data
var bb : blackboard = blackboard.new()
#the state machine that will be running the player
@export var fsm : StateMachine = StateMachine.new()
@export var look_component : player_look
@export var move_component : player_movement

@export var not_melee : bool = true
@export var debug_info_target : Node3D
@export var hit_sounds : audio_set
@export var low_health_audio : AudioStreamPlayer

@export var debug_text_label : Label
var playing_low_health : bool = false

@export_category("camera_shake")
@export var camera_shake_base : Node3D
@export var mag : float
@export var timer : float

@export var ad : AudioStreamPlayer 


#setup our states
func _ready():
	bb.load_from_json("res://Data/JSON/player_settings.json")
	_setup_states()
	#add our components to the blackboard
	bb.set_data("player_look",look_component)
	bb.set_data("player_move",move_component)
	#add our blackboard to the fsm blackboard
	print("player bb: ", str(bb.data.keys()))
	print("player fsm bb before: ", str(fsm.bb.data.keys()))
	fsm.bb.set_data("player_data",bb) #add our blackboard to the fsm
	print("player fsm bb: ", str(fsm.bb.data.keys()))
	print("player bb after: ", str(bb.data.keys()))
	fsm.initialize("roaming")
	print("finished initialize to roam")

	
	GameManager.set_data("player",self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var max_health = GameManager.get_data("player_max_health",1)
	GameManager.set_data("player_health",max_health)
	
	$CollisionShape3D/CSGCylinder3D.queue_free()
	
	GameManager.shake_camera.connect(shake_camera)

func take_damage(damage : int = 1):
	damage = GameManager.process_effect_value(damage,stack_effect.effector.player_damage)
	if damage == 0:
		return
	var health = GameManager.get_data("player_health",1)
	GameManager.set_data("player_health",health - damage)
	health -= damage
	if health <= 0:
		SignalBus.fire_signal("player_killed")
		print("game over")
	else:
		AudioManager.play_random_audio_file(hit_sounds,"default",false,Vector3(0,0,0))


#used to process the current state
func _physics_process(_delta: float) -> void:
	fsm.process()
	pass

func _process(_delta):
	if Input.is_key_pressed(KEY_F1) and OS.has_feature("editor"):
		GameManager.set_data("player_health",0)
	if debug_info_target!=null:
		print("player debug info: [rotation: ", debug_info_target.global_rotation_degrees, "] | {scale: " , debug_info_target.scale , " } | (position: " , debug_info_target.global_position)
	var ratio : float = float(GameManager.get_data("player_health",1)) / float(GameManager.get_data("player_max_health", 5))
	
	if ratio <= 0.2 and !playing_low_health:
		low_health_audio.play()
		playing_low_health = true
	else:
		if playing_low_health and ratio > 0.2:
			low_health_audio.stop()
			playing_low_health = false
	
	timer -= _delta
	do_shake()
	
	lock_player_y() ##<---- for keeping the player from falling through the floor just a fallback

func lock_player_y():
	if global_position.y < 0.3:
		global_position.y = 0.3
		velocity.y = 0


#used to set a reference to the state machine within each state
#needed if states are initialized in the inspector instead of code
func _setup_states():
	for s in fsm.states:
		fsm.states[s].state_machine = fsm

func melee_finished():
	not_melee = true

func shake_camera(magnitude : float, time : float):
	timer = time
	mag = magnitude 

func do_shake():
	if timer > 0:
		camera_shake_base.position = Vector3(
			randf_range(-0.25,0.25) * mag,
			randf_range(-0.25,0.25) * mag,
			randf_range(-0.25,0.25) * mag
		)
	else:
		camera_shake_base.position = Vector3(0,0,0)
