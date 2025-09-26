extends CSGBox3D

@export var x_size : Vector2 = Vector2(3,6)
@export var z_size : Vector2 = Vector2(3,6)
@export var y_size : Vector2 = Vector2(20	,50)

func _ready() -> void:
	size = Vector3(randf_range(x_size.x,x_size.y),randf_range(y_size.x,y_size.y),randf_range(z_size.x,z_size.y))
	position.y = size.y/2
