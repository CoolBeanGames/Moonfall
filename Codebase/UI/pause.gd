class_name pause_menu extends CanvasLayer

#the pause sound
@export var audio : AudioStreamPlayer
#if true, when we press escape it will unpause
@export var unpause_ready : bool = false
#the mouse mode we had set when we entered the pause menu
@export var entry_mouse_mode : Input.MouseMode

func _ready() -> void:
	print("[Pause] spawned pause")
	audio.play()
	entry_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# defer the connection to avoid immediate trigger
	call_deferred("_connect_pause_signal")

func _connect_pause_signal():
	#InputManager.connect_to_action_just_released("pause", onPause)
	pass

func onPause():
	close()

#region UI Buttons
func _on_resume_button_down() -> void:
	onPause()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_to_title_button_down() -> void:
	SignalBus.fire_signal("to_title")
#endregion

func close():
	Input.mouse_mode = entry_mouse_mode
	get_tree().paused=false
	SceneManager.unload_ui("Pause")
	
