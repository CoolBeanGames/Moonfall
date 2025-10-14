extends ColorRect

@export var e : stack_effect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var effect_exists : bool = false
	for e in GameManager.effect_stack:
		if e is player_shield_effect:
			effect_exists = true
	visible = effect_exists
