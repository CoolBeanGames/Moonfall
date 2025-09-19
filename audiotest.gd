extends Node

@export var aSet : audio_set

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_button_down() -> void:
	AudioManager.play_random_audio_file(aSet,"default",false,Vector3(0,0,0))
	pass # Replace with function body.
