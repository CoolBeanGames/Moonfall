##a variant audio_set for holding a selection of audio
##in a named dictionary, so we can pull specific sets of audio
class_name unnamed_audio_set extends audio_set

#the files in the set
@export var files : Array[AudioStream]

#returns one random file
func get_random_file() -> AudioStream:
	return files.pick_random()

#add a new audio file to the Array
func add_entry(audio : AudioStream) -> bool:
	if audio == null:
		push_warning("Warning, attempted to add audio but the audio file was null, skipping")
		return false
	files.append(audio)
	return true

#attempt to remove a file from the list
func remove_entry(audio : AudioStream):
	if files.has(audio):
		files.erase(audio)
		return true
	else:
		push_warning("attempted to remove audio from audio set but it doesnt exist")
		return false
