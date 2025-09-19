##this context tracks the mouse delta for use with the input controls
class_name mouse_axis_context extends axis_context
##stores the axis last value
var value : Vector2

##returns the value for reading
func get_axis_value() -> Vector2:
	return value

##if this is triggered it updates the context signal and sets the value
func on_input(event):
	if event is InputEventMouseMotion:
		value = event.relative
		context_fired.emit(value)
