## Holds the current velocity for WASD-style controls, supporting keyboard and 4-button gamepad
class_name button_axis_context extends axis_context

## Keyboard keys
@export var neg_x_key: Key = Key.KEY_A
@export var pos_x_key: Key = Key.KEY_D
@export var neg_y_key: Key = Key.KEY_S
@export var pos_y_key: Key = Key.KEY_W

## Gamepad buttons
@export var neg_x_button: JoyButton = JoyButton.JOY_BUTTON_DPAD_LEFT
@export var pos_x_button: JoyButton = JoyButton.JOY_BUTTON_DPAD_RIGHT
@export var neg_y_button: JoyButton = JoyButton.JOY_BUTTON_DPAD_DOWN
@export var pos_y_button: JoyButton = JoyButton.JOY_BUTTON_DPAD_UP
@export var joy_device_id: int = 0

## Initializer
func _init(
	x_neg: Key = Key.KEY_A, x_pos: Key = Key.KEY_D,
	y_neg: Key = Key.KEY_S, y_pos: Key = Key.KEY_W,
	joy_neg_x: JoyButton = JoyButton.JOY_BUTTON_DPAD_LEFT,
	joy_pos_x: JoyButton = JoyButton.JOY_BUTTON_DPAD_RIGHT,
	joy_neg_y: JoyButton = JoyButton.JOY_BUTTON_DPAD_DOWN,
	joy_pos_y: JoyButton = JoyButton.JOY_BUTTON_DPAD_UP,
	device: int = 0
) -> void:
	neg_x_key = x_neg
	pos_x_key = x_pos
	neg_y_key = y_neg
	pos_y_key = y_pos

	neg_x_button = joy_neg_x
	pos_x_button = joy_pos_x
	neg_y_button = joy_neg_y
	pos_y_button = joy_pos_y

	joy_device_id = device

## Returns the axis value
func get_axis_value() -> Vector2:
	var x = 0.0
	var y = 0.0

	# ----- Keyboard -----
	if Input.is_physical_key_pressed(pos_x_key):
		x += 1
	if Input.is_physical_key_pressed(neg_x_key):
		x -= 1
	if Input.is_physical_key_pressed(pos_y_key):
		y += 1
	if Input.is_physical_key_pressed(neg_y_key):
		y -= 1

	if InputManager.enable_gamepad:
		# ----- Gamepad -----
		if Input.is_joy_button_pressed(joy_device_id, pos_x_button):
			x += 1
		if Input.is_joy_button_pressed(joy_device_id, neg_x_button):
			x -= 1
		if Input.is_joy_button_pressed(joy_device_id, pos_y_button):
			y += 1
		if Input.is_joy_button_pressed(joy_device_id, neg_y_button):
			y -= 1

	value = Vector2(x, y)
	if value.length() > 0.01:
		context_fired.emit(value)

	return value
