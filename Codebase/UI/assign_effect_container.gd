##a simple little script that assigns its own reference
##on the game manager when its loaded
extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.effect_stack_parent = self
