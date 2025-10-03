extends Node

##a list of all the signals in the game
var signals : signal_collection

###get our signal list
func _ready() -> void:
	signals = load("res://Data/Signals/signal_collection.tres") as signal_collection

###fire a signal from the signal list if it exists
func fire_signal(_name : String):
	print("firing signal: " , _name)
	if signals.signals.has(_name):
		signals.signals[_name].event.emit()
	else:
		push_warning("Attempted to fire signal ", _name , " but the signal does not exist")

###connect a signal from the signal list if it exists
func connect_signal(_name : String, _call : Callable):
	if signals.signals.has(_name):
		signals.signals[_name].event.connect(_call)
	else:
		push_warning("Attempted to connect signal ", _name , " but the signal does not exist")

###disconnect a singal from the signal list if it exists
func disconnect_signal(_name : String, _call : Callable):
	if signals.signals.has(_name):
		signals.signals[_name].event.disconnect(_call)
	else:
		push_warning("Attempted to disconnect signal ", _name , " but the signal does not exist")
