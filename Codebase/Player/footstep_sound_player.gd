extends Node

@export var plr: CharacterBody3D
@export var audio: audio_set
@export var walk_sound_time: float = 0.45
@export var sprint_sound_time: float = 0.2
@export var sprint_speed_ratio_threshold: float = 0.6

var footstep_timer: float = 0.0

func _process(delta: float) -> void:
	if plr == null:
		return
	
	# Player speed magnitude
	var velocity = plr.velocity
	velocity.y=0
	var speed: float = velocity.length()
	
	if speed <= 0.01:
		# Stop footsteps if player is essentially idle
		footstep_timer = 0
		return
	
	# Determine speed ratio relative to sprint threshold
	var speed_ratio: float = speed / 15 # Assuming "run_speed" is max speed
	speed_ratio = clamp(speed_ratio, 0, 1)
	
	print("[Speed Ratio] ", str(speed_ratio))
	
	# Interpolate footstep interval between walk and sprint times
	var interval: float
	if speed_ratio >= sprint_speed_ratio_threshold:
		# Above sprint threshold: scale between sprint_time and walk_time
		var t: float = (speed_ratio - sprint_speed_ratio_threshold) / (1.0 - sprint_speed_ratio_threshold)
		interval = lerp(walk_sound_time, sprint_sound_time, t)
	else:
		# Below sprint threshold: scale from walk_time to walk_time (or slower)
		interval = lerp(walk_sound_time, walk_sound_time * 1.2, 1.0 - (speed_ratio / sprint_speed_ratio_threshold))
	
	# Countdown timer
	footstep_timer -= delta
	if footstep_timer <= 0:
		play_footstep_sound()
		footstep_timer = interval

func play_footstep_sound():
	print("[Audio Foot] playing footstep sound")
	if audio == null:
		return
	AudioManager.play_random_audio_file(audio, "player_footsteps", false, plr.global_transform.origin)
