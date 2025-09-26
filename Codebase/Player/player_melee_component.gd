extends Node

@export var ShootComp : player_shoot_component
@export var melee_targets : Array[melee_target]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		ShootComp.current_gun.melee(melee_targets)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("melee_target"):
		melee_targets.append(body as melee_target)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("melee_target") and melee_targets.has(body as melee_target):
		melee_targets.erase(body as melee_target)
