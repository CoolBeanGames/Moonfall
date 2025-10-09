##a class for a more general item pickup system
class_name item_pickup extends Node3D

##all of the actual code this item should execute on pickup
@export var strategies : Array[strategy]
##the animnation to play
@export var anim : AnimationPlayer
@export var itemData : item_data
@export var spawn_point : Node3D

signal item_picked_up

##when the player hits this item, execute all of its strategies
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		AudioManager.play_audio_file(load("res://Audio/SFX/item_pickup.wav"),"default",false,Vector3(0,0,0),true)
		for s in strategies:
			s.execute(global_position)
		item_picked_up.emit()
		queue_free()

##called to setup the item, assign it all its data and spawn
##the model for it
func setup(data : item_data):
	itemData = data
	var instance : Node3D = data.scene_to_spawn.instantiate()
	spawn_point.add_child(instance)
	instance.global_position = spawn_point.global_position
	instance.scale = data.item_scale
	instance.rotation_degrees = data.item_rotation
	strategies = data.strategies
	
	#play the animation when we are ready to start
	anim.play("hover")
