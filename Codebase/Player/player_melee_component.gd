extends Node

@export var ShootComp : player_shoot_component
@export var melee_targets : Array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		ShootComp.current_gun.melee(melee_targets)

func _on_area_3d_body_entered(body) -> void:
	print("body enter")
	if body.has_method("take_damage"):
		print("has take damage")
		melee_targets.append(body)
	else:
		print(body.name + " does not take damage")

func _on_area_3d_body_exited(body) -> void:
	if body.has_method("take_damage") and melee_targets.has(body):
		melee_targets.erase(body)
