class_name notification_manager extends VBoxContainer

@export var note : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.notification_man = self

func notify(message : String):
	var instance = note.instantiate()
	add_child(instance)
	var n : Label = instance as Label
	n.text = message
