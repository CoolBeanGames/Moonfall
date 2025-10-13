##a variant audio_set for holding a selection of audio
##in a named dictionary, so we can pull specific sets of audio
class_name named_audio_set extends audio_set

#the files in the set
@export var files : Dictionary[StringName,AudioStream] = {}

#returns one random file
func get_random_file() -> AudioStream:
	var keys = files.keys()
	var selection = keys.pick_random()
	return files[selection]

#checks if the key exists in the files
func has_key(key : StringName) -> bool:
	return files.has(key)

#get a specific entry by name
func get_entry(key : StringName) -> AudioStream:
	if has_key(key):
		return files[key]
	else:
		push_warning("Warning: attempted to get audio stream from a set " , key , " but the set does not contain that key, this will return null and may lead to an error")
		return null

#add a new audio file to the dictionary
func add_entry(key : StringName, audio : AudioStream) -> bool:
	if has_key(key):
		push_warning("Warning, attempted to add audio under key " , key , " but that key already exists, skipping")
		return false
	if audio == null:
		push_warning("Warning, attempted to add audio under key " , key , " but the audio file was null, skipping")
		return false
	files[key] = audio
	return true

#attempt to remove a file from the list
func remove_entry(key : StringName):
	if has_key(key):
		files.erase(key)
		return true
	else:
		push_warning("attempted to remove key ", key , " from audio set but it doesnt exist")
		return false
