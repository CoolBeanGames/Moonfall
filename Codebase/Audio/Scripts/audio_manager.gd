##this class is a singleton for managing and playing 
##audio, it is the primary access point for all 
##audio managment
class_name audio_manager extends Node

#the prefab to load in for setting up audio
var audio_player_prefab
var configs : Dictionary = {}

@export var inactive_audio_players : Array = []
@export var active_audio_players : Array = []

#load our prefab
func _ready() -> void:
	audio_player_prefab = load("res://Codebase/Audio/Prefabs/audio_player.tscn")
	if audio_player_prefab == null:
		# Use push_error to show a clear error message in the Godot console
		push_error("Failed to load audio_player.tscn! Check the file path.")
	read_all_configs()

#play an audio file with a json settings file
func play_audio_file(audio : AudioStream, settings : String, use_position : bool, position : Vector3, always_play : bool = false) -> audio_player:
	if active_audio_players.size() < GameManager.get_data("Max_Active_Audio_Sources") or always_play:
		var plr = pop()
		return _setup_from_json(plr,audio,settings,use_position,position)
	else: 
		return null

#play a random audio file loading settings from a json file
func play_random_audio_file(audioSet : audio_set, settings : String, use_position : bool, position : Vector3, always_play : bool = false) -> audio_player:
	if active_audio_players.size() < GameManager.get_data("Max_Active_Audio_Sources") or always_play:
		var plr = pop()
		var audio : AudioStream = audioSet.get_random_file()
		return _setup_from_json(plr,audio,settings,use_position,position)
	return null
#used to setup an audio file with an audio settings json file
func _setup_from_json(plr : audio_player,audio : AudioStream,settings : String, use_position : bool, position : Vector3) -> audio_player:
	return plr.play(audio,settings,use_position,position)

#spawn the audio player in and return it to the top level functions
func spawn_player() -> audio_player:
	var plr = audio_player_prefab.instantiate()
	add_child(plr)
	return plr

#load in all of the audio configs so we dont have to load json every time a sound effect playts
func read_all_configs():
	var files : Array[String] = []
	var path : String = "res://Data/JSON/AudioSettings/"
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json"): #only read files not directories
				files.append(path.path_join(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("could not load audio config path")
		return
	
	for f in files:
		configs[f.get_basename().get_file()] = load_from_json(f)
		print("loaded in ", f.get_basename().get_file() , " new count ", str(configs.size()))
	
#used to load in settings from a json file as specified
#path should ommit folders and the json path
func load_from_json(path : String) -> Dictionary:
	var data : Dictionary
	if(!path.to_lower().contains(".json")):
		push_error("path does not point to a valid json file, cannot open")
		return Dictionary()
	#load the file to text
	var raw_string : String
	var f = FileAccess.open(path,FileAccess.READ)
	if(f == null):
		push_error("failed to open json file (does it exist?) ", path)
		return Dictionary()
	
	raw_string = f.get_as_text()
	
	#parse the file
	var json = JSON.new()
	var error = json.parse(raw_string)
	
	#set the data if valid
	if(error == OK):
		print("successfully loaded json data")
		if typeof(json.data) == TYPE_DICTIONARY:
			data = json.data
		else:
			push_error("Parsed JSON is not a dictionary")
	else:
		push_error("error encountered parsing json data: ", json.get_error_message())
	
	return data
	

##get a player, either active or inactive
func pop():
	if inactive_audio_players.size() == 0:
		return spawn_player()
	var p = inactive_audio_players[0]
	inactive_audio_players.erase(p)
	active_audio_players.append(p)
	return p

##return a player to being inactive
func push(audio):
	active_audio_players.erase(audio)
	inactive_audio_players.append(audio)
