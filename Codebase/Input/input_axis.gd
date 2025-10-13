##this class holds axis values where each value updates
##itself based on an "axis context" resource that 
##updates its data
class_name input_axis extends Resource

##the name for this axis
@export var key : String
##the code to run to update this axis
@export var context : axis_context
signal context_fired(Vector2)

func _init(_context : axis_context) -> void:
	context = _context
	context.context_fired.connect(on_context)

#read the value from our axis
func _get_value() -> Vector2:
	return context.get_axis_value()

func on_context(value : Vector2):
	context_fired.emit(value)
