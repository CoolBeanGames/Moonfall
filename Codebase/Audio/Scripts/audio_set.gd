##the idea for the audio set is a collection of audio files
##in one place that can be easily moved around and shared
##between objects for things like foot step and typing
##sound effects, it will have two variants, one that is 
##named and one that is not
@abstract
class_name audio_set extends Resource

@abstract func get_random_file() -> AudioStream
