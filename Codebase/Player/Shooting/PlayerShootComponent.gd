##this class is responsible for allowing the player to shoot
##their guns calculating the ray forward from the camera
##spawning a effect at the collision point
##playing shoot sounds
##and managing ammo
class_name player_shoot_component extends Node

var shoot_action : input_action_mouse
var reload_action : input_action
var shoot_timer : float = 0
var bullet_hit_effect : PackedScene
@export var current_gun : gun
@export var raycaster : RayCast3D
@export var gun_animation_player : AnimationPlayer
@export var shoot_point : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_action = InputManager.actions["shoot"]
	reload_action = InputManager.actions["reload"]
	shoot_action.just_released.connect(on_shoot)
	shoot_action.pressed.connect(on_shoot_hold)
	reload_action.just_released.connect(reload)
	bullet_hit_effect = load("res://Guns/bullet_hit_effect.tscn")
	GameManager.data.set_data("bullets",24)
	await get_tree().process_frame
	update_ui()
	gun_animation_player.play("idle")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shoot_timer -= delta
	GameManager.data._set("player_gun",current_gun)

func on_shoot():
	if current_gun.fire_mode == gun.FireMode.single:
		if shoot_timer <= 0:
			if current_gun.loaded_bullets > 0:
				shoot_timer = current_gun.fire_rate
				current_gun.loaded_bullets -= 1
				shoot()
			else:
				AudioManager.play_audio_file(current_gun.empty_sound,"default",false,Vector3(0,0,0))

func change_gun(new_gun : gun):
	current_gun = new_gun
	update_ui()

func on_shoot_hold():
	if current_gun.fire_mode == gun.FireMode.rapid:
		if shoot_timer <= 0:
			if current_gun.loaded_bullets > 0:
				shoot_timer = current_gun.fire_rate
				current_gun.loaded_bullets -= 1
				shoot()

func shoot():
	raycaster.force_raycast_update()
	gun_animation_player.play("Shoot")
	AudioManager.play_random_audio_file(current_gun.shooting_sounds,"default",false,Vector3(0,0,0))
	if raycaster.is_colliding():
		var position : Vector3 = raycaster.get_collision_point()
		var collider =  raycaster.get_collider()
		var instance : Node3D = bullet_hit_effect.instantiate()
		instance.position = position
		GameManager.add_child(instance)
		update_ui()
		spawn_bullet(position)
	else:
		spawn_bullet( raycaster.global_position + (raycaster.global_transform.basis.z * raycaster.target_position.z))


func update_ui():
	SignalBus.signals.signals["update_gun_ui"].event.emit()

func reload():
	var bullets = GameManager.data._get("bullets")
	if current_gun.loaded_bullets != 0:
		reload_effects()
		print("loading partial ammount")
		var difference = current_gun.max_clip_size - current_gun.loaded_bullets
		print("difference: ", difference)
		if bullets < difference:
			current_gun.loaded_bullets += bullets
			GameManager.data._set("bullets",0)
			print("added all bullets")
		else:
			reload_effects()
			current_gun.loaded_bullets = current_gun.max_clip_size
			GameManager.data._set("bullets",bullets - difference)
			print("added some bullets")
		update_ui()
		return
	
	if bullets != null and bullets > 0:
		print("bulelts not null and bulelts greater than 0")
		if bullets < current_gun.max_clip_size:
			current_gun.loaded_bullets = bullets
			GameManager.data._set("bullets",0)
			print("added all bullets")
		else:
			current_gun.loaded_bullets = current_gun.max_clip_size
			GameManager.data._set("bullets",bullets - current_gun.max_clip_size)
			print("added some bullets")
	else:
		print("bullets null or no bullets")
	update_ui()

func spawn_bullet(hit_position : Vector3):
	print("spawning bullet, hit point: ", hit_position)
	var direction = (hit_position - shoot_point.global_position).normalized()
	print("direction: ", direction)
	var distance = (hit_position - shoot_point.global_position).length()
	print("distance: ", distance)
	var instance = current_gun.bullet_prefab.instantiate() as bullet
	GameManager.add_child(instance)
	instance.position = shoot_point.global_position
	
	
	instance.rotate_x(deg_to_rad(-90))
	
	
	instance.look_at(hit_position, Vector3.UP)
	
	print("calling shoot")
	instance.shoot(direction, 30, distance)

func reload_effects():
	AudioManager.play_audio_file(current_gun.reload_sound,"default",false,Vector3(0,0,0))
	gun_animation_player.play("Reload")
