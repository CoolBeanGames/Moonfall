class_name event_transition extends Transition

var event : Game_Signal
var fired : bool = false

##setup the transition and assign a condition
func _init(signal_name : String , _state_machine : StateMachine, _to_state : String,_from_state : String, _is_global : bool = false, _priority : int = 0):
	event = SignalBus.signals.signals[signal_name]
	event.event.connect(signal_fired)
	super._init(_state_machine,_to_state,_from_state,_is_global,_priority)

func signal_fired():
	print("event")
	fired = true

##evaluate this transition
func eval(_current_state : String) -> bool:
	#change this for actual logic for transition
	if(is_correct_state() and fired):
		fired=false
		print("event transition fired: ", SignalBus.signals.signals.find_key(event) , " 🏁")
		return true
	return false
