##a class that defines the logic for a gun
##this handles what actually happens when shooting
##a gun
@abstract
class_name gun_strategy extends Resource

@abstract func equip(...params : Array)
@abstract func unequip(...params : Array)
@abstract func shoot(...params : Array)
@abstract func reload(...params : Array)
@abstract func melee(...params : Array)

var blood : PackedScene
var dust : PackedScene
var zombie_hit : audio_set = preload("res://Data/audio_sets/zombie_hit_sounds.tres")

#make sure we arent loading dust and blood every single shot
func load_stuff():
	if blood == null:
		blood = load("res://Scenes/blood_spurt.tscn")
	if dust == null:
		dust = load("res://Scenes/dust_cloud.tscn")

func update_ui():
	SignalBus.fire_signal("update_gun_ui")


func spawn_bloodspurt(global_position : Vector3):
	load_stuff()
	var instance = blood.instantiate()
	SceneManager.get_first_scene().add_child(instance)
	instance.global_position = global_position

func spawn_dust_cloud(global_position : Vector3):
	load_stuff()
	var instance = dust.instantiate()
	SceneManager.get_first_scene().add_child(instance)
	print("dust cloud position: ", str(global_position))
	instance.global_position = global_position
