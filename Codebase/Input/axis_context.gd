##an abstract class for processing axis data such as mouse or wasd movement
@abstract
class_name axis_context extends Resource
signal context_fired(Vector2)

#reads the value from our axis context
@abstract func get_axis_value() -> Vector2
