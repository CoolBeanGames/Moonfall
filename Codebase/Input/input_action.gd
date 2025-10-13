## Holds signals and values for player inputs.
## Supports keyboard, gamepad buttons, mouse buttons, and analog triggers.
class_name input_action
extends Resource

# Input bindings
var key: Key = Key.KEY_NONE
var joy_button: JoyButton = JoyButton.JOY_BUTTON_INVALID
var joy_input_device: int = 0
var mouse_button_index: MouseButton = MouseButton.MOUSE_BUTTON_NONE
var trigger_axis: JoyAxis = JoyAxis.JOY_AXIS_INVALID
var trigger_deadzone: float = 0.5

# State tracking
var state: InputState = InputState.idle
var is_pressed: bool = false
var is_valid: bool = false

# Signals
signal just_pressed
signal just_released
signal pressed

# Enum
enum InputState { pressed, idle }

## Initialization
func _init(
	keyboard_key: Key = Key.KEY_NONE,
	gamepad_button: JoyButton = JoyButton.JOY_BUTTON_INVALID,
	gamepad_device: int = 0,
	mouse_button: MouseButton = MouseButton.MOUSE_BUTTON_NONE,
	trigger: JoyAxis = JoyAxis.JOY_AXIS_INVALID,
	deadzone: float = 0.5
) -> void:
	#print("[Debug Hunt] setting up input on key ", str(keyboard_key), " or gamepad button " , str(gamepad_button) , " or mouse button " , str(mouse_button) , " or trigger " , str(trigger) )
	key = keyboard_key
	joy_button = gamepad_button
	joy_input_device = gamepad_device
	mouse_button_index = mouse_button
	trigger_axis = trigger
	trigger_deadzone = deadzone

	# Validation: must have at least one valid input source
	if key == Key.KEY_NONE \
	and joy_button == JoyButton.JOY_BUTTON_INVALID \
	and mouse_button_index == MouseButton.MOUSE_BUTTON_NONE \
	and trigger_axis == JoyAxis.JOY_AXIS_INVALID:
		push_warning("Warning: input_action initialized without any inputs — this input is invalid.")
		return

	is_valid = true


var was_pressed: bool = false

func evaluate() -> void:
	if not is_valid:
		return

	var key_state = Input.is_physical_key_pressed(key)
	var joy_state = Input.is_joy_button_pressed(joy_input_device, joy_button)
	var mouse_state = mouse_button_index != MouseButton.MOUSE_BUTTON_NONE and Input.is_mouse_button_pressed(mouse_button_index)
	var trigger_state = trigger_axis != JoyAxis.JOY_AXIS_INVALID and Input.get_joy_axis(joy_input_device, trigger_axis) > trigger_deadzone

	var now_pressed = key_state or joy_state or mouse_state or trigger_state

	if now_pressed and not was_pressed:
		just_pressed.emit()
	elif not now_pressed and was_pressed:
		just_released.emit()

	if now_pressed:
		pressed.emit()

	was_pressed = now_pressed



## Helper: check pressed state
func _check_pressed(_is_pressed: bool, _state: InputState) -> Dictionary:
	var fire = {
		"pressed": false,
		"just_pressed": false,
		"just_released": false
	}
	if _is_pressed:
		if _state == InputState.idle:
			fire.just_pressed = true
		fire.pressed = true
	else:
		if _state == InputState.pressed:
			fire.just_released = true
	return fire


## Remapping wrapper
func _reset_inputs(
	keyboard_key: Key = Key.KEY_NONE,
	gamepad_button: JoyButton = JoyButton.JOY_BUTTON_INVALID,
	gamepad_device: int = 0,
	mouse_button: MouseButton = MouseButton.MOUSE_BUTTON_NONE,
	trigger: JoyAxis = JoyAxis.JOY_AXIS_INVALID,
	deadzone: float = 0.5
) -> void:
	_init(keyboard_key, gamepad_button, gamepad_device, mouse_button, trigger, deadzone)
