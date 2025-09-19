##this class defines a transition from one state to another
##esentially if its condition (a callable) returns true
##the transition succeeds ad we transition
##otherwsie it fails and we dont transition
@abstract
class_name Transition extends Resource

##the condition required for this transition
var condition : Callable
##the state we transition to if it returns true
@export var to_state : String
##the state we need to be in for this transition to be valid
@export var from_state : String
##if this is true then from state is ignored
@export var is_global : bool = false
##how important is this transition
@export var priority : int = 0
##the state machine that is using the transition
@export var state_machine : StateMachine

##setup the transition and assign a condition
func _init(_state_machine : StateMachine, _to_state : String,_from_state : String, _is_global : bool = false, _priority : int = 0) -> void:
	to_state = _to_state
	priority = _priority
	from_state = _from_state
	is_global = _is_global
	state_machine = _state_machine

##evaluate this transition
@abstract func eval(current_state : String) -> bool

func is_correct_state() -> bool:
	return from_state == state_machine.states.find_key(state_machine.currentState)
