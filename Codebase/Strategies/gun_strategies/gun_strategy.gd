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

func update_ui():
	SignalBus.fire_signal("update_gun_ui")


func spawn_bloodspurt(global_position : Vector3):
	var blood : PackedScene = load("res://Scenes/blood_spurt.tscn")
	var instance = blood.instantiate()
	SceneManager.get_first_scene().add_child(instance)
	instance.global_position = global_position

func spawn_dust_cloud(global_position : Vector3):
	var dust : PackedScene = load("res://Scenes/dust_cloud.tscn")
	var instance = dust.instantiate()
	SceneManager.get_first_scene().add_child(instance)
	instance.global_position = global_position
