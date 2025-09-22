extends RigidBody3D

@export var piece_container : Node3D
@export var pieces : Array[crate_piece]
@export var main : Node3D
@export var activated : bool = false
@export var spawnables : Array[PackedScene] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in piece_container.get_children():
		pieces.append(c as crate_piece)
	apply_impulse(Vector3.UP)

func melee_damage():
	if !activated:
		freeze=true
		main.queue_free()
		activated = true
		for p in pieces:
			p.t.start()
			p.freeze = false
			var dir := Vector3(
				randf_range(-1.0, 1.0),
				randf_range(0.5, 1.5), # bias upward so they fly up
				randf_range(-1.0, 1.0)
			).normalized()

			# Random strength
			var strength := randf_range(GameManager.data._get("crate_min_force"), GameManager.data._get("crate_max_force"))

			# Apply impulse
			p.apply_impulse(dir * strength)
		spawn()

func spawn():
	if randf_range(0,1.0) < GameManager.data._get("crate_item_chance") and spawnables.size() > 0:
		var inst : Node3D = spawnables.pick_random().instantiate()
		GameManager.add_child(inst)
		inst.global_position = global_position
		inst.global_position.y = 0
