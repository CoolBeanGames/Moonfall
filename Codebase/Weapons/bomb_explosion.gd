extends Node3D

@export var anim : AnimationPlayer

func _ready():
	anim.play("bomb_explode")

func kill():
	GameManager.kill_all_zombies()

func destroy():
	queue_free()
