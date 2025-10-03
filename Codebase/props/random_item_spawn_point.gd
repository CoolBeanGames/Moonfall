class_name Random_Item_Spawn_Point extends Node3D

@export var spawned_item : item_pickup
@export var item_list : item_spawn_list
@export var default_y_pos : float = 0.22
@export var visuals : Node3D

func _ready():
	global_position.y = default_y_pos
	if GameManager.data_has("random_pickups"):
		GameManager.get_data("random_pickups").append(self)
	else:
		GameManager.set_data("random_pickups",[self])
	visuals.queue_free()

func spawn():
	if spawned_item == null:
		spawned_item = item_list.get_item_spawn(global_position)
		if spawned_item != null:
			spawned_item.item_picked_up.connect(spawned_item_picked_up)

func free() -> void:
	GameManager.get_data("random_pickups").erase(self)

func spawned_item_picked_up():
	spawned_item = null
