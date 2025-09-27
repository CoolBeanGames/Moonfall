##strategy that adds a gun to the player
class_name gun_pickup_strategy extends strategy

@export var gun_name : String
@export var spawn_list_index : int = 0

##call to add health to the player
func execute(...params : Array):
	var shoot = GameManager.data.get("player_shoot") as player_shoot_component
	shoot.enabled_guns.append(shoot.guns[gun_name])
	shoot.guns.erase(gun_name)
	var item_spawns : item_spawn_list = load("res://Data/items/item_spawns.tres")
	item_spawns.items.erase(spawn_list_index)
