##this is the singleton class that managesall inputs for the game
class_name input_manager extends Node

#a list of all actions (buttons) to track
var actions : Dictionary[StringName,input_action]
#a list of all axis values to track
var axis : Dictionary[StringName,input_axis]
#fired whenever any key is pressed, used for typing minigame
signal on_any_key(key : String)

##add in all of our actions
func _ready() -> void:
	set_process(true)
	add_actions()
	add_all_axis()

##evaluate all current actions
func _process(delta: float) -> void:
	for ac in actions:
		actions[ac].evaluate() 

##adds all actions to be able to be used in the game
##actions can be accessed based on string name
func add_actions():
	_add_action("confirm",Key.KEY_E)
	_add_action("sprint",Key.KEY_SHIFT)
	_add_mouse_action("shoot")
	_add_action("reload",Key.KEY_R)

##adds all needed axis (scalar) values to track
func add_all_axis():
	_add_axis("wasd",wasd_context.new())
	_add_axis("mouse",mouse_axis_context.new())

##adds a single action
func _add_action(name: String , key : Key):
	var input : input_action = input_action.new()
	input.key = key
	actions[name] = input

func _add_mouse_action(name : String):
	var input : input_action_mouse = input_action_mouse.new()
	input.key = KEY_0
	actions[name] = input

##adds a single axis
func _add_axis(name : String, context : axis_context):
	var ax : input_axis = input_axis.new()
	ax.context = context
	ax.key = name
	ax.context.context_fired.connect(ax.on_context)
	axis[name] = ax
	

#used to process any other input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var m : mouse_axis_context = axis["mouse"].context
		m.on_input(event)
	else:
		if event is InputEventKey and event.is_pressed() and !event.is_echo():
			var key_string : String = OS.get_keycode_string(event.keycode)
			on_any_key.emit(key_string)
	
