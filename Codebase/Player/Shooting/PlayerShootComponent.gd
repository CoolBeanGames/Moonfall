##this class is responsible for allowing the player to shoot
##their guns calculating the ray forward from the camera
##spawning a effect at the collision point
##playing shoot sounds
##and managing ammo
class_name player_shoot_component extends Node

@export var guns : Dictionary[StringName,Node3D]
@export var enabled_guns : Array[Node3D]
@export var current_gun_index : int = 0
@export var current_gun : weapon
@export var raycaster : RayCast3D
@export var plr : player
@export var gun_parent : Node3D


#setup the shoot controller
func _ready() -> void:
	#connect our signals
	InputManager.connect_to_action_pressed("shoot",on_shoot)
	InputManager.connect_to_action_just_released("reload",reload)
	InputManager.connect_to_action_just_released("weaponUp",cycle_up)
	InputManager.connect_to_action_just_released("weaponDown",cycle_down)
	InputManager.scroll_up.connect(cycle_up)
	InputManager.scroll_down.connect(cycle_down)
	current_gun = enabled_guns[current_gun_index]
	var i : int = 0
	for g : weapon in enabled_guns:
		if i == current_gun_index:
			continue
		g.unequip()
		i += 1
	current_gun.equip(gun_parent)	

	#add some starting bullets
	GameManager.set_data("bullets",12)
	GameManager.set_data("player_shoot",self)


#process shot cooldown
func _process(_delta: float) -> void:
	update_ui()

#used for non rapid fire guns
func on_shoot():
	if !InputManager.is_input_locked():
		current_gun.shoot(raycaster)

#update the gun ui
func update_ui():
	GameManager.set_data("player_gun",current_gun.gun_data)
	SignalBus.fire_signal("update_gun_ui")

#reload the gun
func reload():
	if !InputManager.is_input_locked():
		current_gun.reload()

func change_weapon(index : int = 0):
	if index == current_gun_index:
		return
	current_gun.unequip()
	current_gun = enabled_guns[index]
	current_gun.equip(gun_parent)
	current_gun_index = index

func cycle_guns(direction : int):
	var index : int = current_gun_index
	index += direction
	if index >= enabled_guns.size():
		index = 0
	if index < 0:
		index = enabled_guns.size() - 1
	change_weapon(index)
	update_ui()

func cycle_up():
	SignalBus.fire_signal("weapon_changed")
	print("[Cycle] cycle up")
	cycle_guns(1)

func cycle_down():
	SignalBus.fire_signal("weapon_changed")
	print("[Cycle] cycle down")
	cycle_guns(-1)
