##a script for controlling a specitic audio player
##that will get spawned by the audio manager
class_name audio_player extends Node

#holds data needed to play an audio file
var data : Dictionary

@export var global_player : AudioStreamPlayer
@export var local_player : AudioStreamPlayer3D

signal playback_finished

#used to setup the player with a settings json object
func play(audio : AudioStream, 
settings_name : String, 
use_position : bool = false, 
position : Vector3 = Vector3(0,0,0)) -> audio_player:
	load_from_json(settings_name)
	_finish_setup(audio,use_position,position)
	return self

#use to setup the player WITHOUT a settings json file
func play_manual(audio : AudioStream, 
repeat : bool, 
bus : String, 
volume : float, 
pitch : float, 
randomize_pitch : bool, 
pitch_range_min : float, 
pitch_range_max : float, 
use_position : bool = false, 
position : Vector3 = Vector3(0,0,0)) -> audio_player:
	#load in all the data into the dictionary
	data["repeat"] = repeat
	data["bus"] = bus
	data["volume"] = volume
	data["pitch"] = pitch
	data["pitch_range_max"] = pitch_range_max
	data["pitch_range_min"] = pitch_range_min
	
	#finish setting up so we can continue
	_finish_setup(audio,use_position,position)
	
	return self

#finialize setting up the audio player
func _finish_setup(audio : AudioStream, use_position : bool, position : Vector3):
	if use_position:
		_setup_3D(audio,position)
		return
	_setup_2D(audio)

#play a global sound file
func _setup_2D(audio : AudioStream):
	#setup the audio file
	global_player.stream = audio
	global_player.volume_linear = data.get("volume",0.5)
	var pitch : float = data.get("pitch",1)
	if data.get("randomize_pitch",false):
		global_player.pitch_scale = randf_range(data.get("pitch_range_min",1),data.get("pitch_range_max",1))
	global_player.bus = data.get("bus","Master")
	global_player.play()
	
	if data.get("repeat",false):
		global_player.finished.connect(audio_finished)

#play a 3d positional sound file
func _setup_3D(audio : AudioStream, position : Vector3):
	#setup the audio file
	local_player.stream = audio
	local_player.volume_linear = data.get("volume",0.5)
	var pitch : float = data.get("pitch",1)
	if data.get("randomize_pitch",false):
		pitch = randf_range(data.get("pitch_range_min",1),data.get("pitch_range_max",1))
	local_player.pitch_scale = pitch
	local_player.bus = data.get("bus","Master")
	local_player.global_position = position
	local_player.play()
	
	if data.get("repeat",false):
		local_player.finished.connect(audio_finished)

#called when a player finishes, allows the playback finished signal to
#fire off and estroyes the object
func audio_finished():
	playback_finished.emit()
	free()

#used to load in settings from a json file as specified
#path should ommit folders and the json path
func load_from_json(path : String):
	path = "res://Data/JSON/AudioSettings/" + path + ".json"
	if(!path.to_lower().contains(".json")):
		push_error("path does not point to a valid json file, cannot open")
		return
	#load the file to text
	var raw_string : String
	var f = FileAccess.open(path,FileAccess.READ)
	if(f == null):
		push_error("failed to open json file (does it exist?) ", path)
		return
	
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
