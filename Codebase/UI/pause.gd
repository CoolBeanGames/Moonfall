extends CanvasLayer

@export var audio : AudioStreamPlayer
@export var unpause_ready : bool = false

@export_category("ui elements")
@export var master_volume : HSlider
@export var sfx_volume : HSlider
@export var music_volume : HSlider
@export var look_sensitivity : HSlider
@export var invert_y : CheckButton

@export var entry_mouse_mode : Input.MouseMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.play()
	GameManager.load_settings()
	master_volume.value = GameManager.settings_data.data.get("master_volume")
	sfx_volume.value = GameManager.settings_data.data.get("sfx_volume")
	music_volume.value = GameManager.settings_data.data.get("music_volume")
	look_sensitivity.value = GameManager.settings_data.data.get("look_sensitivity")
	invert_y.button_pressed = GameManager.settings_data.data.get("invert_y")

	entry_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta):
	if Input.is_action_just_released("pause"):
		if unpause_ready:
			close()
		else:
			unpause_ready = true
	


func _on_to_title_button_down() -> void:
	SignalBus.fire_signal("to_title")

func _on_invert_y_toggled(toggled_on: bool) -> void:
	GameManager.settings_data.data.set("invert_y",toggled_on)
	GameManager.save_settings()


func _on_look_sensitivity_drag_ended(_value_changed: bool) -> void:
	GameManager.settings_data.data.set("look_sensitivity",look_sensitivity.value)
	GameManager.save_settings()


func _on_music_volume_drag_ended(_value_changed: bool) -> void:
	GameManager.settings_data.data.set("music_volume",music_volume.value)
	GameManager.save_settings()
	update_audio_bus("Music", music_volume.value)


func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	GameManager.settings_data.data.set("sfx_volume",sfx_volume.value)
	GameManager.save_settings()
	update_audio_bus("SoundEffects", sfx_volume.value)

func _on_master_volume_drag_ended(_value_changed: bool) -> void:
	GameManager.settings_data.data.set("master_volume",master_volume.value)
	GameManager.save_settings()
	update_audio_bus("Master", master_volume.value)

func update_audio_bus(bus_name : String,volume_linear : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name) , linear_to_db(volume_linear))

func _on_resume_button_down() -> void:
	close()

func _on_quit_button_down() -> void:
	get_tree().quit()

func close():
	Input.mouse_mode = entry_mouse_mode
	get_tree().paused=false
	SceneManager.unload_ui("Pause")
