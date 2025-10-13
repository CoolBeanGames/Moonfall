## A context for a single analog trigger (e.g., gamepad RT or LT)
class_name trigger_context extends axis_context

# The gamepad axis to read
@export var joy_axis: JoyAxis = JoyAxis.JOY_AXIS_TRIGGER_RIGHT
@export var joy_device_id: int = 0
@export var deadzone: float = 0.05  # ignore tiny values

## Initializer
func _init(axis: JoyAxis = JoyAxis.JOY_AXIS_TRIGGER_RIGHT, device: int = 0, dead_zone: float = 0.05) -> void:
	joy_axis = axis
	joy_device_id = device
	deadzone = dead_zone

## Returns the trigger value as a float
func get_axis_value() -> Vector2:
	if InputManager.enable_gamepad:
		var raw_value = Input.get_joy_axis(joy_device_id, joy_axis)

		# Apply deadzone
		if abs(raw_value) < deadzone:
			raw_value = 0.0

		# For consistency with axis_context, store in Vector2.y
		value = Vector2(0, raw_value)

		if abs(raw_value) > 0.0:
			context_fired.emit(value)

		return value
	return Vector2(0,0)
