##this class is a singleton for managing and playing 
##audio, it is the primary access point for all 
##audio managment
extends Node

#the prefab to load in for setting up audio
var audio_player_prefab

#load our prefab
func _ready() -> void:
	audio_player_prefab = load("res://Codebase/Audio/Prefabs/audio_player.tscn")
	if audio_player_prefab == null:
		# Use push_error to show a clear error message in the Godot console
		push_error("Failed to load audio_player.tscn! Check the file path.")

#play an audio file with a json settings file
func play_audio_file(audio : AudioStream, settings : String, use_position : bool, position : Vector3) -> audio_player:
	var player = spawn_player()
	return _setup_from_json(player,audio,settings,use_position,position)

#play a random audio file loading settings from a json file
func play_random_audio_file(audioSet : audio_set, settings : String, use_position : bool, position : Vector3) -> audio_player:
	var player = spawn_player()
	var audio : AudioStream = audioSet.get_random_file()
	return _setup_from_json(player,audio,settings,use_position,position)

#play a audio file with manual setup
func play_audio_file_manual(audio : AudioStream, 
repeat : bool, 
bus : String, 
volume : float, 
pitch : float, 
randomize_pitch : bool, 
pitch_range_min : float, 
pitch_range_max : float, 
use_position : bool = false, 
position : Vector3 = Vector3(0,0,0)) -> audio_player:
	var player = spawn_player()
	return _setup(player,audio,repeat,bus,volume,pitch,randomize_pitch,pitch_range_min,pitch_range_max,use_position,position) 

#play a random audio file from a audio set with a manual setup
func play_random_audio_file_manual(audioSet : audio_set, 
repeat : bool, 
bus : String, 
volume : float, 
pitch : float, 
randomize_pitch : bool, 
pitch_range_min : float, 
pitch_range_max : float, 
use_position : bool = false, 
position : Vector3 = Vector3(0,0,0)) -> audio_player:
	var player = spawn_player()
	var audio = audioSet.get_random_file()
	return _setup(player,audio,repeat,bus,volume,pitch,randomize_pitch,pitch_range_min,pitch_range_max,use_position,position) 

#used to setup an audio file with an audio settings json file
func _setup_from_json(player : audio_player,audio : AudioStream,settings : String, use_position : bool, position : Vector3) -> audio_player:
	return player.play(audio,settings,use_position,position)

#used to setup an audio file manually
func _setup(player : audio_player,
audio : AudioStream, 
repeat : bool, 
bus : String, 
volume : float, 
pitch : float, 
randomize_pitch : bool, 
pitch_range_min : float, 
pitch_range_max : float, 
use_position : bool = false, 
position : Vector3 = Vector3(0,0,0)) -> audio_player:
	return player.play_manual(audio,repeat,bus,volume,pitch,randomize_pitch,pitch_range_min,pitch_range_max,use_position,position)

#spawn the audio player in and return it to the top level functions
func spawn_player() -> audio_player:
	var player = audio_player_prefab.instantiate()
	add_child(player)
	return player
