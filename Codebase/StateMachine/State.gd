##this is a base class for a state
##actual states should override this 
##as it stands it wont actually do anything
@abstract
class_name State extends Resource

##the parent state machien that owns this state
@export var state_machine : StateMachine

##set this states machine
func _init(_state_machine : StateMachine = null) -> void:
	state_machine = _state_machine


##called once when entering the state and then not again until it has finished
func on_enter():
	pass

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
