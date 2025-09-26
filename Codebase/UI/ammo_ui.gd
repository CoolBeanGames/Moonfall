##this class is responsible for showing how much ammo the player has
class_name ammo_ui extends Control

#the total ammount of ammothe player has
@export var total_ammo : Label
#the display for how much ammo is loaded in
@export var loaded_ammo : Label
#the display for the current guns name
@export var gun_name : Label
@export var ammo_bar : ColorRect
#a reference to the players current gun
var player_gun : gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	update_ui()
	SignalBus.signals.signals["update_gun_ui"].event.connect(update_ui)

#updates the UI when new data is present (bullets have been shot or gained)
func update_ui():
	print("update ui")
	player_gun = GameManager.data._get("player_gun")
	if player_gun == null:
		return
	total_ammo.text = str(GameManager.data.data.get("bullets",0))
	loaded_ammo.text = str(player_gun.loaded_bullets) + " / " + str(player_gun.max_clip_size)
	print("player gun name from ammo ui: ", player_gun.gun_name)
	gun_name.text = player_gun.gun_name
	var ratio : float = float(player_gun.loaded_bullets) / float(player_gun.max_clip_size) 
	print(ratio)
	ammo_bar.material.set_shader_parameter("progress",ratio)
