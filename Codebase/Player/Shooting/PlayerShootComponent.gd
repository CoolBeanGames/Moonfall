##this class is responsible for allowing the player to shoot
##their guns calculating the ray forward from the camera
##spawning a effect at the collision point
##playing shoot sounds
##and managing ammo
class_name player_shoot_component extends Node

var shoot_action : input_action_mouse
var reload_action : input_action
@export var guns : Dictionary[StringName,Node3D]
@export var enabled_guns : Array[Node3D]
@export var current_gun : weapon
@export var raycaster : RayCast3D
@export var plr : player
@export var gun_parent : Node3D


#setup the shoot controller
func _ready() -> void:
	#connect our signals
	shoot_action = InputManager.actions["shoot"]
	reload_action = InputManager.actions["reload"]
	shoot_action.pressed.connect(on_shoot)
	reload_action.just_released.connect(reload)	
	#InputManager.scroll_up.connect(cycle_gun_up)
	#InputManager.scroll_down.connect(cycle_gun_down)
	current_gun.equip(gun_parent)	

	#add some starting bullets
	GameManager.data.set_data("bullets",12)
	GameManager.data.set_data("player_shoot",self)


#process shot cooldown
func _process(_delta: float) -> void:
	update_ui()

#used for non rapid fire guns
func on_shoot():
	if !InputManager.is_input_locked():
		current_gun.shoot(raycaster)

#update the gun ui
func update_ui():
	GameManager.data._set("player_gun",current_gun.gun_data)
	SignalBus.fire_signal("update_gun_ui")

#reload the gun
func reload():
	if !InputManager.is_input_locked():
		current_gun.reload()

#spawn a single bullet
func spawn_bullet(hit_position : Vector3):
	pass