##this is the singleton class that managesall inputs for the game
#v1 added basic input stuff
#v2 moved helpers into sub classes and created new helpers for accessing values

class_name input_manager extends Node

#a list of all actions (buttons) to track
var actions : Dictionary[StringName,input_action] = {}
#a list of all axis values to track
var axis : Dictionary[StringName,input_axis] = {}
#turn this off if you dont want to use gamepad stuff
var enable_gamepad : bool = true
var input_lockers : Dictionary[StringName,Node] = {}
#fired whenever any key is pressed, used for typing minigame
signal on_any_key(key : String)
signal scroll_up
signal scroll_down

##add in all of our actions
func _ready() -> void:
	print("Connected Joypads: ", Input.get_connected_joypads())
	#print("[Debug Hunt] setting up player inputs")
	set_process(true)
	process_mode = PROCESS_MODE_ALWAYS
	add_actions()
	add_all_axis()

##evaluate all current actions
func _process(_delta: float) -> void:
	#poll for buttons
	for ac in actions:
		if GameManager.get_tree().paused and ac == "pause":
			continue
		actions[ac].evaluate()
	#poll for controller xis
	for ax in axis:
		if axis[ax].context is joy_axis_context:
			axis[ax].on_context(axis[ax].context.get_axis_value())
	if Input.get_connected_joypads().size() > 0:
		var device := Input.get_connected_joypads()[0]
		for i in range(16):
			if Input.is_joy_button_pressed(device, i):
				print("Pressed button:", i)

##adds all actions to be able to be used in the game
##actions can be accessed based on string name
func add_actions():
	actions["confirm"] = input_action.new(Key.KEY_E,JoyButton.JOY_BUTTON_A,0)
	actions["cancel"] = input_action.new(Key.KEY_Q,JoyButton.JOY_BUTTON_B,0)
	actions["shoot"] = input_action.new(Key.KEY_NONE,JoyButton.JOY_BUTTON_INVALID,0,MouseButton.MOUSE_BUTTON_LEFT,JoyAxis.JOY_AXIS_TRIGGER_RIGHT,0.5)
	actions["melee"] = input_action.new(Key.KEY_NONE,JoyButton.JOY_BUTTON_RIGHT_STICK,0,MouseButton.MOUSE_BUTTON_RIGHT)
	actions["weaponUp"] = input_action.new(Key.KEY_NONE,JoyButton.JOY_BUTTON_RIGHT_SHOULDER,0,MouseButton.MOUSE_BUTTON_WHEEL_UP)
	actions["weaponDown"] = input_action.new(Key.KEY_NONE,JoyButton.JOY_BUTTON_LEFT_SHOULDER,0,MouseButton.MOUSE_BUTTON_WHEEL_DOWN)
	actions["reload"] = input_action.new(Key.KEY_R,JoyButton.JOY_BUTTON_X)
	actions["jump"] = input_action.new(Key.KEY_SPACE,JoyButton.JOY_BUTTON_Y)
	actions["sprint"] = input_action.new(Key.KEY_SHIFT,JoyButton.JOY_BUTTON_LEFT_STICK,0)
	actions["pause"] = input_action.new(Key.KEY_ESCAPE,JoyButton.JOY_BUTTON_INVALID,0)

##adds all needed axis (scalar) values to track
func add_all_axis():
	axis["wasd"] = input_axis.new(button_axis_context.new(Key.KEY_A,Key.KEY_D,Key.KEY_S,Key.KEY_W,JoyButton.JOY_BUTTON_DPAD_LEFT,JoyButton.JOY_BUTTON_DPAD_RIGHT,JoyButton.JOY_BUTTON_DPAD_DOWN,JoyButton.JOY_BUTTON_DPAD_UP))
	axis["look_stick"] = input_axis.new(joy_axis_context.new(JoyAxis.JOY_AXIS_RIGHT_X,JoyAxis.JOY_AXIS_RIGHT_Y,0,0.15,10,false))
	axis["mouse"] = input_axis.new(mouse_axis_context.new())
	axis["move_stick"] = input_axis.new(joy_axis_context.new(JoyAxis.JOY_AXIS_LEFT_X,JoyAxis.JOY_AXIS_LEFT_Y,0,0.15,1,true))

#connect to actions
func connect_to_action_pressed(action : String, to_call: Callable):
	if actions.has(action):
		actions[action].pressed.connect(to_call)

func connect_to_action_just_pressed(action : String, to_call: Callable):
	if actions.has(action):
		actions[action].just_pressed.connect(to_call)

func connect_to_action_just_released(action : String, to_call: Callable):
	if actions.has(action):
		actions[action].just_released.connect(to_call)

#disconnect from actions
func disconnect_to_action_pressed(action : String, to_call: Callable):
	if actions.has(action) and actions[action].pressed.get_connections().has(to_call):
		actions[action].pressed.disconnect(to_call)

func disconnect_to_action_just_pressed(action : String, to_call: Callable):
	if actions.has(action) and actions[action].just_pressed.get_connections().has(to_call):
		actions[action].just_pressed.disconnect(to_call)

func disconnect_to_action_just_released(action : String, to_call: Callable):
	if actions.has(action) and actions[action].just_released.get_connections().has(to_call):
		actions[action].just_released.disconnect(to_call)

#connect to axis
func connect_to_axis(target_axis : String, to_call: Callable):
	print("Connecting to axis [",target_axis,"]")
	if axis.has(target_axis):
		axis[target_axis].context_fired.connect(to_call)
		print("Connection result: \n", str(axis[target_axis].context_fired.get_connections()))
	else:
		push_warning("Attempted to connect to axis ", target_axis, " but axis does not exist")

#disconnect from axis
func disconnect_to_axis(target_axis : String, to_call: Callable):
	if axis.has(target_axis) and axis[target_axis].context_fired.get_connections().has(to_call):
		axis[target_axis].context_fired.disconnect(to_call)

#reads the value from a single axis
func read_axis_value(target_axis : String) -> Vector2:
	if axis.has(target_axis):
		return axis[target_axis]._get_value()
	else:
		push_warning("Warning, Attempted to read a non existant axis value ", target_axis)
		return Vector2(0,0)

#used to process any other input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var m : mouse_axis_context = axis["mouse"].context
		m.on_input(event)
	else:
		if event is InputEventKey and event.is_pressed() and !event.is_echo():
			var key_string : String = OS.get_keycode_string(event.keycode)
			on_any_key.emit(key_string)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll_up.emit()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll_down.emit()

func lock_input(locker : StringName, n: Node):
	if input_lockers.has(locker):
		return
	input_lockers[locker] = n

func unlock_input(locker : StringName):
	if input_lockers.has(locker):
		input_lockers.erase(locker)

func is_input_locked() -> bool:
	return input_lockers.size() > 0
