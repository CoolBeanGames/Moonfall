##base class for a state machine 
##all of the actual code will be inside 
##the overriden states but this class
##contains the data for the basics
class_name StateMachine extends Resource

##the state we are currently processing
@export var currentState : State
##a dictionary of all of our states
@export var states : Dictionary[String,State]
##all of the possible transitions
@export var transitions : Array[Transition]
##a list of all of the data for this state machine
var bb : blackboard = blackboard.new()

##set up our initial state
func initialize(starting_state : String) -> void:
	currentState = states[starting_state]
	currentState.on_enter()

##more direct access for reading blackboard values
func _get(property: StringName) -> Variant:
	return bb[property]

##more direct access for writing blackboard data
func _set(property: StringName, value: Variant) -> bool:
	bb[property] = value
	return true

##check all of our transitions one by one looking for a valid option
func check_transitions():
	var found_transition : bool = false
	var current_transition : Transition
	
	#loop through transitions
	for t in transitions:
		if t.eval(currentState.to_string()):
			found_transition = true
			if current_transition == null or current_transition.priority < t.priority:
				current_transition = t
	
	#if we found a transition then change
	if found_transition and current_transition!= null and states.has(current_transition.to_state):
		currentState.on_exit()
		currentState = states[current_transition.to_state]
		currentState.on_enter()

##run tick on our current state
func process():
	if currentState == null:
		push_warning("State machine has no current state set, aborting")
		return
	check_transitions()
	currentState.tick()
