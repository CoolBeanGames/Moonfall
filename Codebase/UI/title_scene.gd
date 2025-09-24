extends Node3D

@export var title_anim : AnimationPlayer

func _ready() -> void:
	title_anim.play("fade_in")

func _on_start_button_down() -> void:
	print("start clicked")
	title_anim.play("explode")

func load_game():
	if !GameManager.save_data.has("intro_seen"):
		SignalBus.fire_signal("to_intro")
	else:
		SignalBus.fire_signal("new_game_clicked")
