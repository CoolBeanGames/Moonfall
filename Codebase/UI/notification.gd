extends Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(end_intro)
	create_tween().tween_property(self,"modulate",Color(1,1,1,1),2)

func end_intro():
	get_tree().create_timer(5).timeout.connect(start_fade)

func start_fade():
	get_tree().create_timer(2).timeout.connect(end_fade)
	create_tween().tween_property(self,"modulate",Color(1,1,1,0),2)

func end_fade():
	queue_free()
