extends Control

@export var text : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.signals.signals["update_score"].event.connect(update_ui)
	pass # Replace with function body.

func update_ui():
	text.text = str(GameManager.get_data("score"))
