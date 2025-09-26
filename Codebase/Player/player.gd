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


#setup our states
func _ready():
	bb.load_from_json("res://Data/JSON/player_settings.json")
	_setup_states()
	fsm.initialize("roaming")

	#add our components to the blackboard
	bb.set("player_look",look_component)
	bb.set("player_move",move_component)

	#add our blackboard to the fsm blackboard
	fsm.bb.set("player_data",bb) #add our blackboard to the fsm
	
	GameManager.data._set("player",self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var max_health = GameManager.data.data.get("player_max_health",1)
	GameManager.data.data.set("player_health",max_health)

func take_damage(damage : int = 1):
	var health = GameManager.data.data.get("player_health",1)
	GameManager.data.data.set("player_health",health - damage)
	health -= damage
	if health <= 0:
		SignalBus.signals.signals["player_killed"].event.emit()
		print("game over")
	else:
		AudioManager.play_random_audio_file(hit_sounds,"default",false,Vector3(0,0,0))


#used to process the current state
func _physics_process(_delta: float) -> void:
	fsm.process()
	pass

func _process(_delta):
	if debug_info_target!=null:
		print("player debug info: [rotation: ", debug_info_target.global_rotation_degrees, "] | {scale: " , debug_info_target.scale , " } | (position: " , debug_info_target.global_position)
	var ratio : float = float(GameManager.data.data.get("player_health",1)) / float(GameManager.data.data.get("player_max_health", 5))
	
	if ratio <= 0.2 and !playing_low_health:
		low_health_audio.play()
		playing_low_health = true
	else:
		if playing_low_health and ratio > 0.2:
			low_health_audio.stop()
			playing_low_health = false


#used to set a reference to the state machine within each state
#needed if states are initialized in the inspector instead of code
func _setup_states():
	for s in fsm.states:
		fsm.states[s].state_machine = fsm

func melee_finished():
	not_melee = true
