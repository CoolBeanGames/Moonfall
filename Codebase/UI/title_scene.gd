extends Node3D

@export var title_anim : AnimationPlayer
@export var replay_intro_button : Button
@export var instrumental_audio : AudioStreamPlayer
@export var targets_label : Label

@export var settings_visibility_parent : Control
@export var hide_settings_button : Button
@export var settings_menu : Control
@export var settings_open : bool = false
@export var leaderboard_open : bool = false

@export var disable_on_settings : Array[Button]

@export var leaderboard : score_display_ui
@export var leaderboard_visiblility_target : Control

@export var delete_if_game_not_finished : Array[Control]

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
	
	if !GameManager.save_data.has("has_finished_game"):
		for d in delete_if_game_not_finished:
			d.queue_free()

func play_instrumental():
	instrumental_audio.play()

#start the intro animation
func _on_start_button_down() -> void:
	if !settings_open and !leaderboard_open:
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
	if !settings_open and !leaderboard_open:
		if is_instance_valid(GameManager.start_music):
			GameManager.start_music.fade_out(3)
		title_anim.play("to_intro")


func on_credits() -> void:
	if !settings_open and !leaderboard_open:
		if is_instance_valid(GameManager.start_music):
			GameManager.start_music.fade_out(3)
		title_anim.play("to_credits")

func to_credits():
	if !settings_open and !leaderboard_open:
		SignalBus.fire_signal("to_credits")

func to_intro():
	if !settings_open and !leaderboard_open:
		SignalBus.fire_signal("to_intro")



func _on_close_settings_button_button_down() -> void:
	toggle_settings()

func _on_settings_button_down() -> void:
	if !settings_open and !leaderboard_open:
		toggle_settings()
	

func toggle_settings():
	settings_open = !settings_open
	settings_visibility_parent.visible = settings_open


func _on_close_leaderboard_button_2_button_down() -> void:
	toggle_leaderboard()


func _on_leaderboard_button_down() -> void:
	toggle_leaderboard()

func toggle_leaderboard():
	leaderboard_open = !leaderboard_open
	if leaderboard_open:
		leaderboard.show_score_ui()
	leaderboard_visiblility_target.visible = leaderboard_open
