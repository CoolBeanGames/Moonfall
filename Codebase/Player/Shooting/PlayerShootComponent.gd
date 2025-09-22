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
@export var guns : Array[gun] = [load("res://Guns/gun data/pistol.tres")]
@export var gun_models : Array[Node3D] = []
@export var fire_points : Array[Node3D] = []
var current_gun_index : int = 0


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
	
	InputManager.scroll_up.connect(cycle_gun_up)
	InputManager.scroll_down.connect(cycle_gun_down)
	


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
				print("rapid shoot")
				shoot()

func shoot():
	raycaster.force_raycast_update()
	gun_animation_player.play("Shoot")
	AudioManager.play_random_audio_file(current_gun.shooting_sounds,"default",false,Vector3(0,0,0))
	if raycaster.is_colliding():
		var position : Vector3 = raycaster.get_collision_point()
		var _collider =  raycaster.get_collider()
		var instance : Node3D = bullet_hit_effect.instantiate()
		instance.position = position
		GameManager.add_child(instance)
		update_ui()
		spawn_bullet(position)
		do_damage(raycaster.get_collider())
	else:
		spawn_bullet( raycaster.global_position + (raycaster.global_transform.basis.z * raycaster.target_position.z))

func do_damage(collider : CollisionObject3D):
	if collider.is_in_group("HeadShotZone"):
		var source : zombie_reference = collider as zombie_reference
		source.z.take_damage(current_gun.bullet_damage * 3)
	else:
		if collider.is_in_group("BodyShotZone"):
			var source : zombie_reference = collider as zombie_reference
			source.z.take_damage(current_gun.bullet_damage)
		else:
			if collider.is_in_group("crate"):
				print("collider is crate")
				collider.melee_damage()
	pass

func update_ui():
	SignalBus.signals.signals["update_gun_ui"].event.emit()

func reload():
	var bullets = GameManager.data._get("bullets")
	if current_gun.loaded_bullets != 0:
		reload_effects()
		var difference = current_gun.max_clip_size - current_gun.loaded_bullets
		if bullets < difference:
			current_gun.loaded_bullets += bullets
			GameManager.data._set("bullets",0)
		else:
			reload_effects()
			current_gun.loaded_bullets = current_gun.max_clip_size
			GameManager.data._set("bullets",bullets - difference)
		update_ui()
		return
	
	if bullets != null and bullets > 0:
		reload_effects()
		if bullets < current_gun.max_clip_size:
			current_gun.loaded_bullets = bullets
			GameManager.data._set("bullets",0)
		else:
			current_gun.loaded_bullets = current_gun.max_clip_size
			GameManager.data._set("bullets",bullets - current_gun.max_clip_size)
	update_ui()

func spawn_bullet(hit_position : Vector3):
	var direction = (hit_position - shoot_point.global_position).normalized()
	var distance = (hit_position - shoot_point.global_position).length()
	var instance = current_gun.bullet_prefab.instantiate() as bullet
	GameManager.add_child(instance)
	instance.position = shoot_point.global_position
	
	
	instance.rotate_x(deg_to_rad(-90))
	
	
	instance.look_at(hit_position, Vector3.UP)
	
	instance.shoot(direction, 30, distance)

func reload_effects():
	AudioManager.play_audio_file(current_gun.reload_sound,"default",false,Vector3(0,0,0))
	gun_animation_player.play("Reload")

func cycle_gun_up():
	cycle_gun(1)

func cycle_gun_down():
	cycle_gun(-1)

func cycle_gun(dir : int):
	print("cycling guns")
	current_gun_index += dir
	if current_gun_index < 0:
		current_gun_index = guns.size() - 1
	if current_gun_index >= guns.size():
		current_gun_index = 0
	if guns[current_gun_index] == current_gun:
		return
	current_gun = guns[current_gun_index]
	shoot_point = fire_points[current_gun_index]
	update_models(current_gun_index)
	update_ui()

func update_models(index : int):
	var counter : int = 0
	for m : Node3D in gun_models:
		if counter != index:
			m.visible = false
		else:
			m.visible = true
		counter += 1
