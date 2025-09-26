##controls the spawnable items
class_name crate extends RigidBody3D

##the list of spawnable items
@export var spawn_items : item_spawn_list
##the scene for the broken crate pieces
@export var crate_broken : PackedScene

##make sure physics are awake
func _ready() -> void:
	apply_impulse(Vector3.UP)
	rotate_y(randf_range(-30,30))

##called when the crate takes damage
func take_damage(_damage : int = 0):
	spawn()
	queue_free()

##call to spawn an item
func spawn():
	#play the broken crate audio
	AudioManager.play_random_audio_file(load("res://Data/audio_sets/crate_break.tres"),"default",true,global_position)
	if !is_instance_valid(spawn_items):
		spawn_items = load("res://Data/items/item_spawns.tres")
	
	#spawn the broken crate
	var instance = crate_broken.instantiate()
	get_parent().add_child(instance)
	instance.global_position = global_position
	
	#try to get a spawnable item
	spawn_items.get_item_spawn(global_position)
