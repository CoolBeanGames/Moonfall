##a script for controlling a specitic audio player
##that will get spawned by the audio manager
class_name audio_player extends Node

#holds data needed to play an audio file
var data : Dictionary

#the global player for 2D audio
@export var global_player : AudioStreamPlayer
#local audio player for 3D audio
@export var local_player : AudioStreamPlayer3D

#called when this player finishes (if its not looping)
signal playback_finished

#used to setup the player with a settings json object
func play(audio : AudioStream, 
settings_name : String, 
use_position : bool = false, 
position : Vector3 = Vector3(0,0,0)) -> audio_player:
	if !AudioManager.configs.has(settings_name):
		push_warning("tried to load config ", settings_name, " but it does not exist")
		push_warning("available configs: ", str(AudioManager.configs.keys()))
		return self
	data = AudioManager.configs.get(settings_name)
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
	var _pitch : float = data.get("pitch",1)
	if data.get("randomize_pitch",false):
		global_player.pitch_scale = randf_range(data.get("pitch_range_min",1),data.get("pitch_range_max",1))
	global_player.bus = data.get("bus","Master")
	global_player.play()
	
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
	
	local_player.finished.connect(audio_finished)

#called when a player finishes, allows the playback finished signal to
#fire off and estroyes the object
func audio_finished():
	print("audio finished")
	playback_finished.emit()
	queue_free()

#stop the audio player immediatly
func stop():
	local_player.stop()
	global_player.stop()

#for gradually fading out the music
func fade_out(time : float):
	var t_l = create_tween()
	t_l.tween_property(local_player,"volume_db",linear_to_db(0.001),time)
	
	var t_g = create_tween()
	t_g.tween_property(global_player,"volume_db",linear_to_db(0.001),time)
