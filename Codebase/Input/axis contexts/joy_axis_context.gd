class_name joy_axis_context extends axis_context

@export var horizontal_axis: JoyAxis = JoyAxis.JOY_AXIS_LEFT_X
@export var vertical_axis: JoyAxis = JoyAxis.JOY_AXIS_LEFT_Y
@export var device_id: int = 0
@export var deadzone: float = 0.15
@export var joy_scale : float = 1.0
@export var flip_y : bool = false

func _init(h_axis: JoyAxis = JoyAxis.JOY_AXIS_LEFT_X, v_axis: JoyAxis = JoyAxis.JOY_AXIS_LEFT_Y, device: int = 0, dead_zone: float = 0.15, scale : float = 1.0, flipY : bool = false) -> void:
	self.horizontal_axis = h_axis
	self.vertical_axis = v_axis
	self.device_id = device
	self.deadzone = dead_zone
	self.joy_scale = scale
	self.flip_y = flipY

func get_axis_value() -> Vector2:
	if InputManager.enable_gamepad:
		var raw_value = Vector2(
			Input.get_joy_axis(device_id, horizontal_axis),
			Input.get_joy_axis(device_id, vertical_axis)
		)

		value = raw_value if raw_value.length() > deadzone else Vector2.ZERO
		context_fired.emit(value)
		print("[Control] value: " , str(value))
		if flip_y:
			value.y *= -1
		return value * joy_scale
	return Vector2(0,0)
