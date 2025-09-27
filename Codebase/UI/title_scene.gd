extends Node3D

@export var title_anim : AnimationPlayer
@export var replay_intro_button : Button
@export var instrumental_audio : AudioStreamPlayer
@export var targets_label : Label

func _ready() -> void:
	title_anim.play("fade_in")
	
	#if you havent seen the intro than erase this button
	if !GameManager.save_data.has("intro_seen"):
		replay_intro_button.queue_free()
	
	SignalBus.connect_signal("intro_music_done",play_instrumental)
	GameManager.load_save()
	if !GameManager.save_data.has("destroyed_targets"):
		
		targets_label.queue_free()
	else:
		targets_label.text = "Targets Destroyed: " + str(GameManager.save_data.data.get("destroyed_targets",0))

func play_instrumental():
	instrumental_audio.play()

#start the intro animation
func _on_start_button_down() -> void:
	print("start clicked")
	if is_instance_valid(GameManager.start_music):
		GameManager.start_music.fade_out(3)
	title_anim.play("explode")

#load into the game (play game clicked)
func load_game():
	if !GameManager.save_data.has("intro_seen"):
		SignalBus.fire_signal("to_intro")
	else:
		SignalBus.fire_signal("new_game_clicked")

#play the intro again if you have already seen it
func on_replay_intro() -> void:
	if is_instance_valid(GameManager.start_music):
		GameManager.start_music.fade_out(3)
	title_anim.play("to_intro")


func on_credits() -> void:
	if is_instance_valid(GameManager.start_music):
		GameManager.start_music.fade_out(3)
	title_anim.play("to_credits")

func to_credits():
	SignalBus.fire_signal("to_credits")

func to_intro():
	SignalBus.fire_signal("to_intro")
