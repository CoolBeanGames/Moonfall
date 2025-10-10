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

@export var effect_stack : Array[stack_effect]
@export var effect_stack_parent : HBoxContainer

var random_item_spawn_timer : float
#endregion

signal shake_camera(magnitude, time)

@export var resolution_array : Array = [
	Vector2(1024,768),
	Vector2(1280,720),
	Vector2(1280,800),
	Vector2(1366,768),
	Vector2(1280,1024),
	Vector2(1440,900),
	Vector2(1600,900),
	Vector2(1680,1050),
	Vector2(1920,1080),
	Vector2(1920,1200),
	Vector2(2560,1440),
	Vector2(2560,1600),
	Vector2(3440,1440),
	Vector2(3840,2160),
	Vector2(5120,1440),
	Vector2(7680,4320)
]

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

#region effects
##process all the effects against a value
func process_effect_value(value, type : stack_effect.effector) -> Variant:
	for e in effect_stack:
		value = e.effect(value,type)
	return value

##adds an effect to the effect stack
func add_effect(effect : stack_effect , time : float):
	if !effect_stack.has(effect):
		effect_stack.append(effect)
		var instance = effect.display_scene.instantiate()
		effect_stack_parent.add_child(instance)
		var display : effect_display = instance
		display.setup(effect,time)
#endregion

func start_intro_audio():
	start_music = AudioManager.play_audio_file(load("res://Audio/Music/title/1181305_Heartsick-Feat-Agassi.mp3"),"default",false,Vector3(0,0,0))
	start_music.playback_finished.connect(music_ended)

##called when the intro music ends
func music_ended():
	SignalBus.fire_signal("intro_music_done")


func _process(delta: float) -> void:
	fsm.process()
	data.set_data("delta",delta)

	var fps = Engine.get_frames_per_second()
	set_data("fps_ratio",fps / 60.0)

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
	fsm.transitions = []
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
	var e_t : event_transition = event_transition.new("to_title",fsm,"Preload","Lose")
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
	authenticate_settings()
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
	print("[Score] increasing score, input is ", str(ammount))
	var adjusted : int = process_effect_value(ammount,stack_effect.effector.score)
	var score : int = get_data("score",0)
	print("[Score] output ", str(adjusted))
	set_data("score",score + adjusted)
	print("[Score] new value: " , str(score + adjusted))
	SignalBus.fire_signal("update_score")

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

#called to erase all in game data
func reset_data():
	effect_stack = []
	data.load_from_json("res://config.json")

#makes all audio stop and returns it to the source
func purge_all_audio():
	for a in AudioManager.active_audio_players:
		a.stop()

##a new system for randomly spawning items within the world
##this way we are not so dependant on crates to break
func random_item_spawning():
	random_item_spawn_timer += get_data("delta")
	if random_item_spawn_timer >= get_data("Random_Item_Spawn_Check_Time"):
		var spawner : Random_Item_Spawn_Point = get_data("random_pickups")[randi_range(0,get_data("random_pickups").size()-1)]
		spawner.spawn()
		random_item_spawn_timer = 0

func apply_current_resolution():
	##resolution setup
	var current_res : Vector2
	if GameManager.save_data.has("resolution"):
		var res_value = GameManager.save_data.get_data("resolution", GameManager.resolution_array[0])

		# Handle both Vector2 and string cases safely
		if typeof(res_value) == TYPE_STRING and res_value.begins_with("Vector2("):
			current_res = str_to_var(res_value)
		elif typeof(res_value) == TYPE_VECTOR2:
			current_res = res_value
		else:
			print("⚠️ Unexpected resolution format:", res_value)
			current_res = GameManager.resolution_array[0]
	else:
		current_res = get_window().size
	var res_index = find_nearest_resolution(current_res)	
	set_resolution(resolution_array[res_index])

##set  (apply) the game resolution and full screen
func set_resolution(resolution : Vector2i):
	get_window().size = resolution
	get_window().position = (DisplayServer.screen_get_size() - resolution) / 2
	GameManager.save_data.set_data("resolution",resolution)
	GameManager.save_game()
	
	apply_fullscreen()

##applies the current saved full screen data to the screen
func apply_fullscreen():
	var is_fullscreen = GameManager.save_data.get_data("fullscreen",true)
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func find_nearest_resolution(current_resolution :  Vector2) -> int:
	##does it exactly contain the resolution?
	var idx = GameManager.resolution_array.find(current_resolution)
	if idx != -1:
		return idx
		
	##find one with the same y or x value
	for i in GameManager.resolution_array.size():
		if GameManager.resolution_array[i].y == current_resolution.y or GameManager.resolution_array[i].x == current_resolution.x:
			return i
	
	var target_ratio = current_resolution.x / current_resolution.y
	var target_pixels = current_resolution.x * current_resolution.y

	var best_index = 0
	var best_score = INF

	for i in GameManager.resolution_array.size():
		var res = GameManager.resolution_array[i]
		var ratio = res.x / res.y
		var pixels = res.x * res.y
		var ratio_diff = abs(ratio - target_ratio)
		var pixel_diff = abs(pixels - target_pixels)
		var score = pixel_diff * 0.0001 + ratio_diff # tweak weighting
		if score < best_score:
			best_score = score
			best_index = i

	return best_index
