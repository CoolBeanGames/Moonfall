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

func _ready() -> void:
	bb.load_from_json(config_json_path)
	print(bb.data)
	bb.set_data("anim",anim)
	bb.set_data("agent",agent)
	bb.set_data("zombie",self)
	add_states()
	add_transitions()
	state_machine.bb._set("bb",bb)
	state_machine.initialize("land")

func add_states():
	_addState("land",zombie_spawn_state.new(state_machine))
	_addState("chase", zombie_chase_state.new(state_machine))


func add_transitions():
	_add_bool_transition("spawned","chase","land")


func _process(delta: float) -> void:
	state_machine.process()

func _addState(state_name : String, s : State):
	state_machine.states[state_name] = s

func _add_bool_transition(bool_name : String,to_state : String, from_state : String):
	var t : blackboard_bool_transition = blackboard_bool_transition.new(bool_name,state_machine,to_state,from_state)
	state_machine.transitions.append(t)

func _add_event_transition(event_name : String,to_state : String, from_state : String):
	var t : event_transition = event_transition.new(event_name,state_machine,to_state,from_state)
	state_machine.transitions.append(t)

func spawn_anim_done():
	print("spawned")
	state_machine.bb._set("spawned",true)
