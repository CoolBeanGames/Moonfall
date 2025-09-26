extends Node

@export var plr : player
@export var pistolAnimator : AnimationPlayer
@export var melee_targets : Array[melee_target]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if plr.not_melee and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		plr.not_melee = false
		pistolAnimator.play("Melee")

func melee_damage():
	if melee_targets.size() > 0:
		for m in melee_targets:
			m.melee_damage()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("melee_target"):
		melee_targets.append(body as melee_target)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("melee_target") and melee_targets.has(body as melee_target):
		melee_targets.erase(body as melee_target)
