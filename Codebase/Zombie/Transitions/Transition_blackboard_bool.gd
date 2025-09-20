class_name blackboard_bool_transition extends Transition

var bool_name : String
var debug_value : bool

##setup the transition and assign a condition
func _init(BoolName : String, _state_machine : StateMachine, _to_state : String,_from_state : String, _is_global : bool = false, _priority : int = 0, debug : bool = false):
	bool_name = BoolName
	debug_value = debug
	super._init(_state_machine,_to_state,_from_state,_is_global,_priority)

##evaluate this transition
func eval(current_state : String) -> bool:
	#change this for actual logic for transition
	if debug_value:
		print("evaluating bool: " , bool_name, " value: ", state_machine.bb._get(bool_name))
	if(is_correct_state() and state_machine.bb._get(bool_name) == true):
		return true
	return false
