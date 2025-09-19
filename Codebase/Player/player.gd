##base class for the player manager
class_name player extends CharacterBody3D

#blackboard for holding all character specific data
var bb : blackboard = blackboard.new()
#the state machine that will be running the player
@export var fsm : StateMachine = StateMachine.new()
@export var look_component : player_look
@export var move_component : player_movement


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



#used to process the current state
func _physics_process(_delta: float) -> void:
	fsm.process()
	pass

#used to set a reference to the state machine within each state
#needed if states are initialized in the inspector instead of code
func _setup_states():
	for s in fsm.states:
		fsm.states[s].state_machine = fsm
