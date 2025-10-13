#this class just registers this object as the root for the game
class_name game_root extends Node

@export var debug_label : Label

func _ready() -> void:
	GameManager.root_node = self

func print_log(message : String):
	print(message)
	#debug_label.text = message
