extends State
class_name GameState

var zombie_spawn_time_max : float = 0.25
var zombie_spawn_chance : float = 0.4
var max_zombies : int = 20
var timer = 0
var zombie_y : float = 0.122
var zom : PackedScene
var zombie_spawn_audio : audio_set

##called once when entering the state and then not again until it has finished
func on_enter():
	GameManager.data._set("score",0)
	SceneManager.load_scene(load("res://Scenes/GameScene.tscn"),"game",true)
	zom = load("res://Scenes/zombie.tscn")
	GameManager.data._set("zombie_count",0)
	InputManager.lock_input("start_game_cooldown",GameManager)
	await GameManager.get_tree().process_frame
	await GameManager.get_tree().process_frame
	await GameManager.get_tree().process_frame
	InputManager.unlock_input("start_game_cooldown")

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	var current_spawn_time : float = zombie_spawn_time_max / ratio(0.8)
	var current_max_zombies = max_zombies / (1-ratio())
	if GameManager.data._get("zombie_count") < current_max_zombies:
		timer += delta()
		if timer >= current_spawn_time:
			timer -= current_spawn_time
			spawn()

func ratio(scale : float = 1) -> float:
	return GameManager.data.data.get("time_ratio",0) * scale

func delta() -> float:
	return GameManager.data.data.get("delta",0)

func spawn():
	if GameManager.zombie_spawners.size() <= 0:
		return
	var instance : CharacterBody3D = zom.instantiate()
	var parent : Node3D = SceneManager.active_scenes[SceneManager.active_scenes.keys()[0]]
	parent.add_child(instance)
	var position = GameManager.zombie_spawners.pick_random().global_position
	position.y = zombie_y
	instance.global_position = position
	AudioManager.play_random_audio_file(load("res://Data/audio_sets/zombie_spawn_sounds.tres"),"zombie_noises",true,position)
