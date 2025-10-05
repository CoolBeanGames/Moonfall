class_name pause_menu extends CanvasLayer

#the pause sound
@export var audio : AudioStreamPlayer
#if true, when we press escape it will unpause
@export var unpause_ready : bool = false
#the mouse mode we had set when we entered the pause menu
@export var entry_mouse_mode : Input.MouseMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.play()
	entry_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta):
	if Input.is_action_just_released("pause"):
		if unpause_ready:
			close()
		else:
			unpause_ready = true
	
#region UI Buttons
func _on_resume_button_down() -> void:
	close()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_to_title_button_down() -> void:
	SignalBus.fire_signal("to_title")
#endregion

func close():
	Input.mouse_mode = entry_mouse_mode
	get_tree().paused=false
	SceneManager.unload_ui("Pause")
