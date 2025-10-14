extends HBoxContainer

@export var heart_scene : PackedScene
@export var hearts_spawned : Array[TextureRect] = []
@export var full_heart : Texture
@export var empty_heart : Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_hearts()
	SignalBus.connect_signal("player_health_changed",update_hearts)

func spawn_hearts():
	for i in GameManager.get_data("player_max_health",5):
		var instance = heart_scene.instantiate()
		add_child(instance)
		hearts_spawned.append(instance)
	update_hearts()

func update_hearts():
	var max_health : int = GameManager.get_data("player_max_health",5)
	var health : int = GameManager.get_data("player_health",5)
	#var counter : int = max_health - 1
	var counter : int = 0
	for i in hearts_spawned:
		#if counter < 0:
		if health > counter:
			i.texture = full_heart
		else:
			i.texture = empty_heart
		counter += 1
