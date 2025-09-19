# meta-name: Transition-Default
# meta-description: A Base class for defining a FSM Transition
# meta-default: true
# meta-space-indent: 4
class_name replace_me extends Transition

##setup the transition and assign a condition
func _init(_state_machine : StateMachine, _to_state : String,_from_state : String, _is_global : bool = false, _priority : int = 0):
	super._init(_state_machine,_to_state,_from_state,_is_global,_priority)

##evaluate this transition
func eval(current_state : String) -> bool:
	#change this for actual logic for transition
	if(current_state == from_state):
		return true
	return false
