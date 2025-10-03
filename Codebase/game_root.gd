#this class just registers this object as the root for the game
extends Node

func _ready() -> void:
	GameManager.root_node = self
