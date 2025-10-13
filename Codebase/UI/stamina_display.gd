class_name stamina_display extends Control

@export var display : ColorRect
var tween : Tween
var fade_time : float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.set_data("stamina_display",self)

func free() -> void:
	GameManager.erase_data("stamina_display")

func show_bar():
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(display,"modulate",Color(1,1,1,1),fade_time)


func hide_bar():
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(display,"modulate",Color(1,1,1,0),fade_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if display and display.material:
		display.material.set_shader_parameter("progress",GameManager.get_data("player_stamina",0))
