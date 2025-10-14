##strategy that adds a gun to the player
class_name gun_pickup_strategy extends strategy

@export var gun_name : String
@export var spawn_list_index : int = 0

##call to add health to the player
func execute(..._params : Array):
	var shoot = GameManager.get_data("player_shoot") as player_shoot_component
	if shoot.guns.has(gun_name):
		shoot.enabled_guns.append(shoot.guns[gun_name])
		shoot.guns.erase(gun_name)
		var item_spawns : item_spawn_list = load("res://Data/items/item_spawns.tres")
		if item_spawns.items.has(item_spawns.items[spawn_list_index]):
			item_spawns.items.erase(item_spawns.items[spawn_list_index])
	else:
		GameManager.set_data("bulelts",GameManager.get_data("bullets") + randi_range(3,6))
