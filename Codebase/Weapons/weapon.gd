##holds all the data and commands used to operate a gun
class_name weapon extends Node3D

@export_category("references")
##the point at which the gun fires
@export var shoot_point : Node3D
##the animation player to animate this gun
@export var animation_player : AnimationPlayer
##the bullet to physically shoot out
@export var bullet_prefab : PackedScene
##the data that define this gun
@export var gun_data : gun
##the code to execute this guns shooting
@export var strat : gun_strategy
##the light to flash when shooting
@export var shoot_light : OmniLight3D
##for showing that  a bullet was fired
@export var bullet_tracer : CSGMesh3D

@export_category("data")
##true if this gun is not on cooldown and has bullets
@export var ready_to_shoot : bool = true
##is the gun reloadable
@export var ready_to_reload : bool = false
##countdown until this gun is ready to fire again
@export var cooldown : float = 0
##if you can melee
@export var can_melee : bool = true
@export var melee_targets : Array

##called to shoot the gun
func shoot(raycaster : RayCast3D):
	if ready_to_shoot:
		print("shoot")
		strat.shoot(gun_data,shoot_point,bullet_prefab,animation_player,raycaster)
		cooldown = gun_data.fire_rate
		shoot_light.light_energy = 1
		
		#play gunshot sound
		AudioManager.play_random_audio_file(gun_data.shooting_sounds,"gunshots",true,global_position)

		bullet_tracer.visible = true
		get_tree().create_timer(.1).timeout.connect(bullet_tracer_off) 
		
		GameManager.shake_camera.emit(gun_data.camera_shake,gun_data.camera_shake_time)

func bullet_tracer_off():
	bullet_tracer.visible = false

##called when switching to this gun
func equip(parent : Node3D):
	strat.equip(gun_data,parent)
	visible = true

##called when switching from this gun
func unequip() -> bool:
	if ready_to_shoot:
		strat.unequip()
		visible = false
		return true
	return false

##called when reloading this gun
func reload():
	if ready_to_reload:
		strat.reload(gun_data,animation_player)
		cooldown = gun_data.reload_time
		AudioManager.play_audio_file(gun_data.reload_sound,"gunshots",true,global_position)
		while gun_data.loaded_bullets < gun_data.max_clip_size && GameManager.data.data.get("bullets",0) > 0:
			gun_data.loaded_bullets += 1
			GameManager.data.data.set("bullets",GameManager.data.data.get("bullets",0) -1)

func melee(_melee_targets : Array):
	if can_melee:
		strat.melee(gun_data,_melee_targets,animation_player)
		cooldown = gun_data.melee_time
		
		print("melee targets :" , str(_melee_targets.size()))
		melee_targets = _melee_targets

func _process(delta):
	#process the cooldown
	if cooldown > 0:
		cooldown -= delta
	else:
		cooldown = 0
	ready_to_shoot = cooldown <= 0 and gun_data.loaded_bullets > 0

	##the light
	if shoot_light.light_energy > 0:
		shoot_light.light_energy-= delta * 5
	else:
		shoot_light.light_energy = 0
	
	#check if we can reload this gun
	if gun_data.loaded_bullets < gun_data.max_clip_size and GameManager.data.data.get("bullets",0) > 0 and cooldown <= 0:
		ready_to_reload = true
	else:
		ready_to_reload = false
	
	#check if you can melee
	can_melee = cooldown <= 0

func deal_melee_damage():
	if melee_targets.size() > 0:
		GameManager.shake_camera.emit(0.2,0.1)
		for m  in melee_targets:
			m.take_damage(gun_data.melee_damage)
	