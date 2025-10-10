class_name settings_menu extends Control


@export_category("ui elements")
@export var master_volume : HSlider
@export var sfx_volume : HSlider
@export var music_volume : HSlider
@export var look_sensitivity : HSlider
@export var particle_density_slider : HSlider
@export var graphics_quality : HSlider
@export var invert_y : CheckButton
@export var resolution_label : Label
@export var resolution_index : int = 0
@export var full_screen_toggle : CheckButton
#the mouse mode we had set when we entered the pause menu
@export var entry_mouse_mode : Input.MouseMode

@export var resolution_array : Array = [
	Vector2(1024,768),
	Vector2(1280,720),
	Vector2(1280,800),
	Vector2(1366,768),
	Vector2(1280,1024),
	Vector2(1440,900),
	Vector2(1600,900),
	Vector2(1680,1050),
	Vector2(1920,1080),
	Vector2(1920,1200),
	Vector2(2560,1440),
	Vector2(2560,1600),
	Vector2(3440,1440),
	Vector2(3840,2160),
	Vector2(5120,1440),
	Vector2(7680,4320)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.load_settings()
	#set initial values for all the sliders and toggles
	master_volume.value = GameManager.get_setting("master_volume")
	sfx_volume.value = GameManager.get_setting("sfx_volume")
	music_volume.value = GameManager.get_setting("music_volume")
	look_sensitivity.value = GameManager.get_setting("look_sensitivity")
	invert_y.button_pressed = GameManager.get_setting("invert_y")
	print("particle level:",str(GameManager.get_setting("particle_density")))
	print(str(GameManager.settings_data.data.keys()))
	particle_density_slider.value = GameManager.get_setting("particle_density")
	print("graphics level:",str(GameManager.get_setting("graphics_level")))
	graphics_quality.value = GameManager.get_setting("graphics_level")
	
	##resolution setup
	var current_res : Vector2
	if GameManager.save_data.has("resolution"):
		var res_value = GameManager.save_data.get_data("resolution", resolution_array[0])

		# Handle both Vector2 and string cases safely
		if typeof(res_value) == TYPE_STRING and res_value.begins_with("Vector2("):
			current_res = str_to_var(res_value)
		elif typeof(res_value) == TYPE_VECTOR2:
			current_res = res_value
		else:
			print("⚠️ Unexpected resolution format:", res_value)
			current_res = resolution_array[0]
	else:
		current_res = get_window().size
	var res_index = find_nearest_resolution(current_res)
	print("actual res: ", str(current_res), " nearest resolution in array: ", resolution_array[resolution_index])
	resolution_label.text=str(resolution_array[resolution_index])
	
	set_resolution(resolution_array[resolution_index])
	
	resolution_index = resolution_index
	

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


func _on_graphics_quality_drag_ended(_value_changed: bool) -> void:
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


func _on_fullscreen_down() -> void:
	pass # Replace with function body.


func _on_res_down() -> void:
	resolution_index -= 1
	if resolution_index < 0:
		resolution_index = resolution_array.size() - 1
	update_resolution_text()


func _on_res_up() -> void:
	resolution_index += 1
	if resolution_index >= resolution_array.size():
		resolution_index = 0
	update_resolution_text()

func update_resolution_text(with_star : bool = true):
	var string = str(resolution_array[resolution_index])
	if with_star:
		string = string + "*"
	resolution_label.text = string

func _on_applu_resolution() -> void:
	set_resolution(resolution_array[resolution_index])
	update_resolution_text(false)

##when this function is given a vector 2 resolution it returns the index of the nearest resolution for use
func find_nearest_resolution(current_resolution :  Vector2) -> int:
	##does it exactly contain the resolution?
	var idx = resolution_array.find(current_resolution)
	if idx != -1:
		return idx
		
	##find one with the same y or x value
	for i in resolution_array.size():
		if resolution_array[i].y == current_resolution.y or resolution_array[i].x == current_resolution.x:
			return i
	
	var target_ratio = current_resolution.x / current_resolution.y
	var target_pixels = current_resolution.x * current_resolution.y

	var best_index = 0
	var best_score = INF

	for i in resolution_array.size():
		var res = resolution_array[i]
		var ratio = res.x / res.y
		var pixels = res.x * res.y
		var ratio_diff = abs(ratio - target_ratio)
		var pixel_diff = abs(pixels - target_pixels)
		var score = pixel_diff * 0.0001 + ratio_diff # tweak weighting
		if score < best_score:
			best_score = score
			best_index = i

	return best_index

func set_resolution(resolution : Vector2i):
	get_window().size = resolution
	get_window().position = (DisplayServer.screen_get_size() - resolution) / 2
	GameManager.save_data.set_data("resolution",resolution)
	GameManager.save_game()
	
	set_fullscreen_toggle()

func set_fullscreen_toggle():
	var is_fullscreen = (DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	full_screen_toggle.button_pressed = is_fullscreen
	GameManager.save_data.set_data("fullscreen",is_fullscreen)
	GameManager.save_game()
	
	apply_fullscreen()

func apply_fullscreen():
	var is_fullscreen = GameManager.save_data.get_data("fullscreen",true)
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
