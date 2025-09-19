extends Node

##a list of all the signals in the game
var signals : signal_collection

###get our signal list
func _ready() -> void:
	signals = load("res://Data/Signals/signal_collection.tres") as signal_collection

###fire a signal from the signal list if it exists
func fire_signal(name : String):
	if signals.signals.has(name):
		signals.signals[name].event.emit()
	else:
		push_warning("Attempted to fire signal ", name , " but the signal does not exist")

###connect a signal from the signal list if it exists
func connect_signal(name : String, call : Callable):
	if signals.signals.has(name):
		signals.signals[name].event.connect(call)
	else:
		push_warning("Attempted to connect signal ", name , " but the signal does not exist")

###disconnect a singal from the signal list if it exists
func disconnect_signal(name : String, call : Callable):
	if signals.signals.has(name):
		signals.signals[name].event.disconnect(call)
	else:
		push_warning("Attempted to disconnect signal ", name , " but the signal does not exist")
