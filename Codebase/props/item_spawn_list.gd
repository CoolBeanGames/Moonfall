##a list of all the spawnable items, this
##is all of the items in the game as well
##as the code to choose one based on spawn
##chance
class_name item_spawn_list extends Resource

#the data for all the items that can be spawned in the game
@export var items : Array[item_data] = []
#a reference to the item pickup scene
@export var pickup : PackedScene
@export var spawn_item_chance : float = 0.3

##return an item spawn from the list if one is valid
func get_item_spawn(spawn_position : Vector3) -> item_pickup:
	#if this is true we spawn nothing
	if randf_range(0,1) > spawn_item_chance:
		return null
	
	#do the actual spawning
	var total_chance := 0.0
	for i in items:
		total_chance += i.spawn_chance

	#roll for what we are spawning
	var roll := randf() * total_chance
	var cumulative := 0.0
	var selection : item_data = null
	for i in items:
		cumulative += i.spawn_chance
		if roll <= cumulative:
			selection = i
			break
	
	#no item was selected so stop
	if selection == null:
		return null
	
	#an item was selected so lets set it up
	var instance : item_pickup = pickup.instantiate()
	SceneManager.get_first_scene().add_child(instance)
	instance.global_position = spawn_position
	
	#set it up
	instance.setup(selection)
	
	#and finally return
	if instance != null:
		print("[ITEM] spawned: " , selection.item_name)
	return instance
