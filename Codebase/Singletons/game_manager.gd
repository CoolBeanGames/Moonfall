extends Node

###the data to be stored and accessed system wide
var data : blackboard = blackboard.new()
###the state machine that manages the various game states
var fsm : StateMachine
var zombie_spawners : Array[zombie_spawn_point] = []
var save_data : blackboard = blackboard.new()
var settings_data : blackboard = blackboard.new()

@export var start_music : audio_player
@export var is_paused : bool = false

signal shake_camera(magnitude, time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	data.load_from_json("res://config.json")
	#loadin and initialize all data
	fsm = StateMachine.new()
	
	#turn on processing for this node
	set_process(true)
	
	load_save()
	#add transitions to th
	addTransitions()
	addStates()
	fsm.initialize("Preload")
	
	SilentWolf.configure({
	"api_key": "9uvEWuQGEda3DxZ9KLOEy2HZTX4CgbiB25Vz6zTI",
	"game_id": "Moonfall",
	"log_level": 1
	})
	
	#start playing the intro music
	start_music = AudioManager.play_audio_file(load("res://Audio/Music/title/1181305_Heartsick-Feat-Agassi.mp3"),"default",false,Vector3(0,0,0))
	start_music.playback_finished.connect(music_ended)

	load_settings()
	preset_volumes()

func music_ended():
	SignalBus.fire_signal("intro_music_done")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fsm.process()
	data._set("delta",delta)
	pass

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

func save_game():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/save.json"
	save_data.save_to_encrypted_json(path)

func load_save():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/save.json"
	save_data.load_from_encrypted_json(path)
	if save_data.has("player_name"):
		print("player name: ", save_data.get_data("player_name","p"))

func save_settings():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/settings.json"
	settings_data.save_to_json(path)

func load_settings():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/settings.json"
	settings_data.load_from_json(path)
	if settings_data.data.size() == 0:
		#no data was loaded initializing settings
		settings_data.set("master_volume",0.5)
		settings_data.set("sfx_volume",0.5)
		settings_data.set("music_volume",0.5)
		settings_data.set("look_sensitivity",0.5)
		settings_data.set("invert_y",false)
		print("settings was intialized")
		save_settings()
	else:
		print("settings successfully loaded")
	print(str(settings_data.data))


func kill_all_zombies():
	if data.data.has("all_zombies"):
		for z in data.data.get("all_zombies"):
			if is_instance_valid(z):
				var zom = z as zombie
				zom.kill()
		data.data["all_zombies"].clear()

func increase_score(ammount : int):
	var adjusted : int = ammount * data.data.get("score_mult",1)
	var score : int = data.data.get("score",0)
	data.data.set("score",score + adjusted)

func preset_volumes():
	print(str(settings_data.data))
	update_audio_bus("Music",settings_data.data.get("music_volume"))
	update_audio_bus("SoundEffects",settings_data.data.get("sfx_volume"))
	update_audio_bus("Master",settings_data.data.get("master_volume"))

func update_audio_bus(bus_name : String , volume_linear : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name) , linear_to_db(volume_linear))
	
