extends RigidBody3D

@export var spawnables : Array[PackedScene] = []
@export var crate_broken : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_impulse(Vector3.UP)

func melee_damage():
	spawn()
	queue_free()

func spawn():
	AudioManager.play_random_audio_file(load("res://Data/audio_sets/crate_break.tres"),"default",true,global_position)
	var instance = crate_broken.instantiate()
	get_parent().add_child(instance)
	instance.global_position = global_position
	if randf_range(0,1.0) < GameManager.data._get("crate_item_chance") and spawnables.size() > 0:
		var inst : Node3D = spawnables.pick_random().instantiate()
		GameManager.add_child(inst)
		inst.global_position = global_position
		inst.global_position.y = 0
