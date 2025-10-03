class_name pause_menu extends CanvasLayer

#the pause sound
@export var audio : AudioStreamPlayer
#if true, when we press escape it will unpause
@export var unpause_ready : bool = false

@export_category("ui elements")
@export var master_volume : HSlider
@export var sfx_volume : HSlider
@export var music_volume : HSlider
@export var look_sensitivity : HSlider
@export var particle_density_slider : HSlider
@export var graphics_quality : HSlider
@export var invert_y : CheckButton
#the mouse mode we had set when we entered the pause menu
@export var entry_mouse_mode : Input.MouseMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.play()
	GameManager.load_settings()
	#set initial values for all the sliders and toggles
	master_volume.value = GameManager.get_setting("master_volume")
	sfx_volume.value = GameManager.get_setting("sfx_volume")
	music_volume.value = GameManager.get_setting("music_volume")
	look_sensitivity.value = GameManager.get_setting("look_sensitivity")
	invert_y.button_pressed = GameManager.get_setting("invert_y")
	particle_density_slider.value = GameManager.get_setting("particle_density")
	print("graphics level:",str(GameManager.get_setting("graphics_level")))
	graphics_quality.value = GameManager.get_setting("graphics_level")

	entry_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta):
	if Input.is_action_just_released("pause"):
		if unpause_ready:
			close()
		else:
			unpause_ready = true
	



#region UI Element Signals
func _on_invert_y_toggled(toggled_on: bool) -> void:
	GameManager.set_setting("invert_y",toggled_on)
	GameManager.save_settings()


func _on_look_sensitivity_drag_ended(_value_changed: bool) -> void:
	GameManager.set_setting("look_sensitivity",look_sensitivity.value)
	GameManager.save_settings()


func _on_music_volume_drag_ended(_value_changed: bool) -> void:
	GameManager.set_setting("music_volume",music_volume.value)
	GameManager.save_settings()
	GameManager.update_audio_bus("Music", music_volume.value)


func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	GameManager.set_setting("sfx_volume",sfx_volume.value)
	GameManager.save_settings()
	GameManager.update_audio_bus("SoundEffects", sfx_volume.value)

func _on_master_volume_drag_ended(_value_changed: bool) -> void:
	GameManager.set_setting("master_volume",master_volume.value)
	GameManager.save_settings()
	GameManager.update_audio_bus("Master", master_volume.value)

func _on_particle_density_drag_ended(_value_changed: bool) -> void:
	GameManager.set_setting("particle_density",particle_density_slider.value)
	GameManager.save_settings()


func _on_graphics_quality_drag_ended(value_changed: bool) -> void:
	GameManager.set_setting("graphics_level",graphics_quality.value)
	SignalBus.fire_signal("update_lod")
	GameManager.save_settings()
#endregion

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
