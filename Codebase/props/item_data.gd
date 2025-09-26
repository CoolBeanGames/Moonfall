##data used for spawning a item pickup
##this class contains the actual data 
class_name item_data extends Resource

#how likely is this item to spanwn?
@export var spawn_chance : float = 0.2 ##percentage chance of spawning in decimal

@export_category("item data")
#the name of the item, just for system use
@export var item_name : StringName
#the model scene to spawn in
@export var scene_to_spawn : PackedScene
#all of the code to run on the item
@export var strategies : Array[strategy]
#how large to scale the model to after spawn
@export var item_scale : Vector3 = Vector3(1,1,1)
