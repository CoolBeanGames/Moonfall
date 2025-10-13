class_name pause_menu extends CanvasLayer

#the pause sound
@export var audio : AudioStreamPlayer
#if true, when we press escape it will unpause
@export var unpause_ready : bool = false
#the mouse mode we had set when we entered the pause menu
@export var entry_mouse_mode : Input.MouseMode

@export var button_press_sound : AudioStream
@export var menu_close_sound : AudioStream

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
	play_click_sound()
	onPause()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_to_title_button_down() -> void:
	play_click_sound()
	SignalBus.fire_signal("to_title")
#endregion

func close():
	play_close_sound()
	Input.mouse_mode = entry_mouse_mode
	get_tree().paused=false
	SceneManager.unload_ui("Pause")

func play_click_sound(...params):
	AudioManager.play_audio_file(button_press_sound,"ui",false,Vector3(0,0,0),true,0.83)

func play_close_sound(...params):
	AudioManager.play_audio_file(menu_close_sound,"ui",false,Vector3(0,0,0),true,)
