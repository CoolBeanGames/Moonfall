##holds the current velocity for wasd controls
class_name wasd_context extends axis_context

#the value last read by the wasd context
@export var value : Vector2

#return the axis current value
func get_axis_value() -> Vector2:
	value = Input.get_vector("left","right","down","up")
	if value.length() > 0.01:
		context_fired.emit(value)
	return value
