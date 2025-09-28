##this class is used for controlling the zombies
##it contains their character controllers
##navigation code state machine and 
##blackboards
class_name zombie extends CharacterBody3D

var bb : blackboard = blackboard.new()
var state_machine : StateMachine =  StateMachine.new()
@export var config_json_path : String
@export var intial_state_name : String
@export var anim : AnimationPlayer
@export var agent : NavigationAgent3D
#used for tracking if we can attack the player or not
@export var player_attack_range : player_tracker
@export var player_damage_range : player_tracker
@export var ammo_clip : PackedScene
@export var materials : Array[Material]
@export var material_target : MeshInstance3D
@export var zombie_hit_sound : AudioStream
@export var zombie_die_sound : AudioStream

@export var spawnables : item_spawn_list

func _ready() -> void:
	if !GameManager.data.data.has("all_zombies"):
		var z : Array[zombie] = [self]
		GameManager.data.data.set("all_zombies",z)
	else:
		GameManager.data.data["all_zombies"].append(self)
	bb.load_from_json(config_json_path)
	print(bb.data)
	bb.set_data("anim",anim)
	bb.set_data("agent",agent)
	bb.set_data("zombie",self)
	add_states()
	add_transitions()
	state_machine.bb._set("bb",bb)
	state_machine.initialize("land")
	ammo_clip= load("res://Scenes/Props/bullet_pickup.tscn")
	material_target.material_override = materials.pick_random()
	bb._set("health",bb._get("health") + int((5 * GameManager.data.data.get("time_ratio",0))))



func add_states():
	_addState("land",zombie_spawn_state.new(state_machine))
	_addState("chase", zombie_chase_state.new(state_machine))
	_addState("attack",zombie_attack_state.new(state_machine))
	_addState("dead",zombie_dead.new(state_machine))
	_addState("hurt",zombie_hurt_state.new(state_machine))


func add_transitions():
	_add_bool_transition("spawned","chase","land")
	_add_bool_transition("player_in_range","attack","chase")
	_add_bool_transition("attack_finished","chase","attack")

	_add_bool_transition("dead","dead","chase",true)
	_add_bool_transition("dead","dead","attack",true)
	_add_bool_transition("dead","dead","land",true)
	_add_bool_transition("dead","dead","hurt",true)

	_add_bool_transition("hurt","hurt","chase",false)
	_add_bool_transition("hurt","hurt","attack",false)
	_add_bool_transition("hurt","hurt","land",false)
	_add_inverted_bool_transition("hurt","chase","hurt",false)


func _process(_delta: float) -> void:
	if !bb._get("end_process") == true:
		#set our range data
		state_machine.bb._set("player_can_damage",player_damage_range.is_inside)
		state_machine.bb._set("player_in_range",player_attack_range.is_inside)
		state_machine.process()

func _addState(state_name : String, s : State):
	state_machine.states[state_name] = s

func _add_bool_transition(bool_name : String , to_state : String , from_state : String,debug : bool = false):
	var t : blackboard_bool_transition = blackboard_bool_transition.new(bool_name,state_machine,to_state,from_state,debug)
	state_machine.transitions.append(t)

func _add_inverted_bool_transition(bool_name : String , to_state : String , from_state : String,debug : bool = false):
	var t : blackboard_inverted_bool_transition = blackboard_inverted_bool_transition.new(bool_name,state_machine,to_state,from_state,debug)
	state_machine.transitions.append(t)

func _add_event_transition(event_name : String,to_state : String, from_state : String):
	var t : event_transition = event_transition.new(event_name,state_machine,to_state,from_state)
	state_machine.transitions.append(t)

func spawn_anim_done():
	state_machine.bb._set("spawned",true)

func attack_anim_done():
	state_machine.bb._set("attack_finished",true)

func deal_player_damagage():
	if player_damage_range.is_inside:
		print("player took damage")
		var play : player = GameManager.data.data.get("player",null)
		if play:
			play.take_damage()
			GameManager.shake_camera.emit(1,.2)

func take_damage(damage : int):
	if !state_machine.bb._get("dead") == true:
		SignalBus.signals.signals["hit_enemy"].event.emit()
		bb._set("health",bb._get("health") - damage)
		if bb._get("health") <= 0:
			AudioManager.play_audio_file(zombie_die_sound,"zombie_noises",true,global_position)
			state_machine.bb._set("dead",true)

			GameManager.pausables.erase(self)

			GameManager.data._set("score",GameManager.data._get("score"))
			if randf_range(0,1) <= bb._get("chance_for_ammo"):
				spawn_bullet_pickup()
		else:
			state_machine.bb.set("hurt",true)
			AudioManager.play_audio_file(zombie_hit_sound,"zombie_noises",true,global_position)

func spawn_bullet_pickup():
	var instance = ammo_clip.instantiate()
	GameManager.add_child(instance)
	instance.global_position = global_position

func melee_damage():
	take_damage(1)

func kill():
	AudioManager.play_audio_file(zombie_die_sound,"zombie_noises",true,global_position)
	state_machine.bb._set("dead",true)
	GameManager.increase_score(1)
	spawnables.get_item_spawn(global_position)


func end_hurt():
	state_machine.bb.set("hurt",false)
