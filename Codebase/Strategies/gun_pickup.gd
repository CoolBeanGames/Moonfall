##strategy that adds a gun to the player
class_name gun_pickup_strategy extends strategy

@export var gun_name : String
@export var item_list : item_spawn_list

##call to add health to the player
func execute(...params : Array):
    #var shoot = GameManager.data.get("player_shoot") as player_shoot_component
    #shoot.enabled_guns.append(shoot.guns[gun_name])
    #shoot.guns.erase(gun_name)
    print("")