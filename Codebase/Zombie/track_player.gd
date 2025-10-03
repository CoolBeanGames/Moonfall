#tracks if the player is within this area 3D
class_name player_tracker extends Area3D

var plr : player
@export var is_inside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	plr = GameManager.get_data("player")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player exit")
		is_inside = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player enter")
		is_inside = true
