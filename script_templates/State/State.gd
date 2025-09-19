# meta-name: State-Default
# meta-description: A Base class for defining a FSM state
# meta-default: true
# meta-space-indent: 4
class_name replace_me extends State

##called once when entering the state and then not again until it has finished
func on_enter():
	pass

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
