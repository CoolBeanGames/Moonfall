##used for displaying the results of adding a powerup
##these will be spawned in a h-box container in the top
##left of the screen, and will tick down over time
##until they are fully removed
class_name effect_display extends Control

@export var active_effect : stack_effect
@export var timer : float = 0
@export var max_time : float
@export var icon : TextureRect
@export var progress_bar : ColorRect

##called to start the processing, takes in the effect we are using and how long to use it
##also sets up the icons and potentially gradiant colors
func setup(effect : stack_effect, time : float = 1):
	print("[Effect Crash] setting values")
	timer = time
	max_time = time
	active_effect = effect
	
	#set up display parameters if they are set in the effect
	if effect.icon_image != null:
		print("[Effect Crash] setting icon")
		icon.texture = effect.icon_image
	if effect.gradient_left_color != null:
		print("[Effect Crash] setting left color")
		progress_bar.material.set_shader_parameter("shader_parameter/progress_color",effect.gradient_left_color)
	if effect.gradient_right_color != null:
		print("[Effect Crash] setting right color")
		progress_bar.material.set_shader_parameter("shader_parameter/gradient_color",effect.gradient_right_color)

##increase the timer and if time is up remove the stack effect
func _process(delta: float) -> void:
	print("[Effect Crash] processing effect display")
	timer -= delta
	if timer <= 0:
		print("[Effect Crash] time is up, removing effect")
		if GameManager.effect_stack.has(active_effect):
			GameManager.effect_stack.erase(active_effect)
		queue_free()
	progress_bar.material.set_shader_parameter("progress",get_ratio())

func get_ratio() -> float:
	print("[Effect Crash] gettomg completion ratio")
	return timer / max_time
