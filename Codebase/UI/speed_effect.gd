extends ColorRect

@export var effect_on_line_counter: float = 2.0
@export var effect_on_distortion_power: float = 0.066
@export var player_move: player_movement
@export var camera_move_fov: float = 47
@export var camera_idle_fov: float = 75
@export var fade_speed: float = 5.0  # higher = faster fade
@export var sprint_threshold: float = 0.6  # minimum speed ratio to trigger sprint effects

# internal state
var current_line: float = 0
var current_distortion: float = 0
var current_fov: float = 75
var current_audio_volume: float = 0

func _process(delta: float) -> void:
	if player_move == null:
		player_move = GameManager.get_data("player_move")
		return
	
	var speed_ratio: float = player_move.plr.velocity.length() / player_move.sprint_speed_minimum
	speed_ratio = clamp(speed_ratio, 0, 1)

	# Only trigger effects if above threshold
	var active: bool = speed_ratio >= sprint_threshold
	var target_line: float = 0
	var target_distortion: float = 0
	var target_fov: float = camera_idle_fov
	var target_audio: float = 0

	if active:
		var effective_ratio = (speed_ratio - sprint_threshold) / (1.0 - sprint_threshold)  # normalize 0–1 above threshold
		target_line = effect_on_line_counter * effective_ratio
		target_distortion = effect_on_distortion_power * effective_ratio
		target_fov = camera_idle_fov - ((camera_idle_fov - camera_move_fov) * effective_ratio)
		target_audio = effective_ratio

	# Smoothly interpolate current values
	current_line = lerp(current_line, target_line, delta * fade_speed)
	current_distortion = lerp(current_distortion, target_distortion, delta * fade_speed)
	current_fov = lerp(current_fov, target_fov, delta * fade_speed)
	current_audio_volume = lerp(current_audio_volume, target_audio, delta * fade_speed)

	# Apply shader effects
	if material:
		material.set_shader_parameter("line_count", current_line)
		material.set_shader_parameter("distortion_power", current_distortion)

	# Apply camera FOV
	if player_move.view_camera:
		player_move.view_camera.fov = current_fov

	# Apply sprint audio
	if player_move.sprint_sound:
		player_move.sprint_sound.volume_db = linear_to_db(current_audio_volume)
		if current_audio_volume > 0 and !player_move.sprint_sound.playing:
			player_move.sprint_sound.play()
		elif current_audio_volume <= 0 and player_move.sprint_sound.playing:
			player_move.sprint_sound.stop()
