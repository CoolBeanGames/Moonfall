extends Transition
class_name SplashScreenFinishedTransition

var event_fired : bool = false

##setup the transition and assign a condition
func _init(_state_machine : StateMachine, _to_state : String,_from_state : String, _is_global : bool = false, _priority : int = 0) -> void:
	SignalBus.connect_signal("splash_screen_finished",event)
	super._init(_state_machine,_to_state,_from_state,_is_global,_priority)

##evaluate this transition
func eval(current_state : String) -> bool:
	#change this for actual logic for transition
	if event_fired and is_correct_state():
		event_fired = false
		return true
	return false

func event():
	event_fired = true
