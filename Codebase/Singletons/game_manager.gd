##the base class for managing the game, holds
##the state machine that runs everything
class_name Game_Manager extends Node

#region Fields
###the data to be stored and accessed system wide
var data : blackboard = blackboard.new()
###the state machine that manages the various game states
var fsm : StateMachine
##list of all the zombie spawners so we can pick one when spawning
var zombie_spawners : Array[zombie_spawn_point] = []
##the players current save data
var save_data : blackboard = blackboard.new()
##the settings data
var settings_data : blackboard = blackboard.new()
##the node to add new nodes to
@export var root_node : Node
##the audio player for the lyical version of the music
@export var start_music : audio_player
##if the game is paused or not
@export var is_paused : bool = false
#endregion

signal shake_camera(magnitude, time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	data.load_from_json("res://config.json")
	#loadin and initialize all data
	fsm = StateMachine.new()
	#load all of our data
	load_save()
	load_settings()
	preset_volumes()
	
	#turn on processing for this node
	set_process(true)
		
	#setup our state machine
	addTransitions()
	addStates()
	fsm.initialize("Preload")
	
	#setup silent wolf for the leaderboard
	SilentWolf.configure({
	"api_key": "9uvEWuQGEda3DxZ9KLOEy2HZTX4CgbiB25Vz6zTI",
	"game_id": "Moonfall",
	"log_level": 1
	})
	
	#start playing the intro music
	start_music = AudioManager.play_audio_file(load("res://Audio/Music/title/1181305_Heartsick-Feat-Agassi.mp3"),"default",false,Vector3(0,0,0))
	start_music.playback_finished.connect(music_ended)

##called when the intro music ends
func music_ended():
	SignalBus.fire_signal("intro_music_done")


func _process(delta: float) -> void:
	fsm.process()
	data.set_data("delta",delta)

#region State Machine Setup
##add the states to our machine
func addStates():
	fsm.states["Preload"] = GamePreloadState.new(fsm)
	fsm.states["Splash"] = splash_screen_state.new(fsm)
	fsm.states["Title"] = title_screen_state.new(fsm)
	fsm.states["Game"] = GameState.new(fsm)
	fsm.states["Paused"] = GamePausedState.new(fsm)
	fsm.states["Win"] = GameWinState.new(fsm)
	fsm.states["Lose"] = GameLoseState.new(fsm)
	fsm.states["Intro"] = GameIntroState.new(fsm)
	fsm.states["Credits"] = GameCreditsState.new(fsm)
	

##called to add the transitions needed for the state machine
func addTransitions():
	#transition for moving from loading to splash screens
	fsm.transitions.append(GameLoadingFinishedTransition.new(fsm,"Splash","Preload"))
	var e_i : event_transition = event_transition.new("to_intro",fsm,"Intro","Title")
	fsm.transitions.append(e_i)
	var e_g : event_transition = event_transition.new("start_game",fsm,"Game","Intro")
	fsm.transitions.append(e_g)
	fsm.transitions.append(SplashScreenFinishedTransition.new(fsm,"Title","Splash"))
	fsm.transitions.append(game_finished_transition.new(fsm,"Win","Game"))
	var e : event_transition = event_transition.new("new_game_clicked",fsm,"Game","Title")
	fsm.transitions.append(e)
	var e_k : event_transition = event_transition.new("player_killed",fsm,"Lose","Game")
	fsm.transitions.append(e_k)
	var e_t : event_transition = event_transition.new("to_title",fsm,"Title","Lose")
	fsm.transitions.append(e_t)
	var e_tg : event_transition = event_transition.new("to_title",fsm,"Title","Game")
	fsm.transitions.append(e_tg)
	var e_c : event_transition = event_transition.new("to_credits",fsm,"Credits","Title")
	fsm.transitions.append(e_c)
	var e_tc : event_transition = event_transition.new("to_title",fsm,"Title","Credits")
	fsm.transitions.append(e_tc)
#endregion

#region Saving and Loading
func save_game():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/save.json"
	save_data.save_to_encrypted_json(path)

func load_save():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/save.json"
	save_data.load_from_encrypted_json(path)
	authenticate_settings()

func save_settings():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/settings.json"
	authenticate_settings()
	settings_data.save_to_json(path)

func load_settings():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/settings.json"
	settings_data.load_from_json(path)
	if settings_data.data.size() == 0:
		save_settings()
	else:
		print("settings successfully loaded")
	print(str(settings_data.data))
#endregion

func authenticate_settings():
	check_setting("master_volume",0.5)
	check_setting("sfx_volume",0.5)
	check_setting("music_volume",0.5)
	check_setting("look_sensitivity",0.5)
	check_setting("invert_y",false)
	check_setting("particle_density", 2)
	check_setting("graphics_level",1)


func check_setting(setting_name : String, default_value):
	if settings_data.has(setting_name) and get_setting(setting_name) != null:
		return
	settings_data.set_data(setting_name,default_value)

func kill_all_zombies():
	if data.data.has("all_zombies"):
		for z in data.data.get("all_zombies"):
			if is_instance_valid(z):
				var zom = z as zombie
				zom.kill()
		data.data["all_zombies"].clear()

func increase_score(ammount : int):
	var adjusted : int = ammount * get_data("score_mult",1)
	var score : int = get_data("score",0)
	set_data("score",score + adjusted)

func preset_volumes():
	update_audio_bus("Music",get_setting("music_volume"))
	update_audio_bus("SoundEffects",get_setting("sfx_volume"))
	update_audio_bus("Master",get_setting("master_volume"))

func update_audio_bus(bus_name : String , volume_linear : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name) , linear_to_db(volume_linear))

##helpers for more easily getting and setting data, use these in future projects also
#region Data access helpers
func get_setting(setting_name : String, default_value = null):
	return settings_data.data.get(setting_name,default_value)

func get_data(data_name : String, default_value = null):
	return data.data.get(data_name,default_value)

func set_data(data_name : String, value):
	if value == null:
		push_warning("Tried to set null data to name ", data_name , " this is not allowed")
		return
	data.data.set(data_name,value)

func set_setting(setting_name : String, value):
	if value == null:
		push_warning("Tried to set null setting to name ", setting_name , " this is not allowed")
		return
	settings_data.data.set(setting_name,value)

func data_has(data_name : String) -> bool:
	return data.data.has(data_name)

func setting_gas(setting_name : String) -> bool:
	return settings_data.data.has(setting_name)

func erase_data(data_name : String):
	if data_has(data_name):
		data.data.erase(data_name)
#endregion
