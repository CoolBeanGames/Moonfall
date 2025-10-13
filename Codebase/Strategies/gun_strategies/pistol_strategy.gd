##a class that defines the logic for a gun
##this handles what actually happens when shooting
##a gun
class_name pistol_strategy extends gun_strategy

func equip(..._params : Array):
	update_ui()

func unequip(..._params : Array):
	update_ui()

func shoot(...params : Array):
	params[3].play("shoot_gun")
	params[0].loaded_bullets -= 1
	var raycaster : RayCast3D = params[4] as RayCast3D
	if raycaster.is_colliding() and raycaster.get_collider(): 
		do_damage(params[0],raycaster.get_collider(),raycaster.get_collision_point())
	update_ui()

func reload(...params : Array):
	params[1].play("reload_gun")
	update_ui()

func melee(...params : Array):
	params[2].play("melee")

func do_damage(gun_data : gun, col : CollisionObject3D, global_position : Vector3):
	#calcualte the damage
	var damage : int = 0
	var is_world : bool = true
	if col.is_in_group("BodyShotZone"):
		print("[damage] bodyshot")
		damage = gun_data.bullet_damage
		col = col.z
		spawn_bloodspurt(global_position)
		is_world = false
		AudioManager.play_random_audio_file(zombie_hit,"gunshots",true,col.position)
		SignalBus.fire_signal("hit_enemy")
	if col.is_in_group("HeadShotZone"):
		print("[damage] headshot")
		damage = gun_data.bullet_damage * 2
		col = col.z
		spawn_bloodspurt(global_position)
		SignalBus.fire_signal("hit_enemy")
		is_world = false
		AudioManager.play_random_audio_file(zombie_hit,"gunshots",true,col.position)
		SignalBus.fire_signal("hit_enemy")
	if col.is_in_group("crate"):
		damage = 0
	if col.is_in_group("target"):
		damage = 0
		is_world = false
	
	if is_world:
		print("spawn dust")
		spawn_dust_cloud(global_position)
		

	#deal the damage we calculated
	if col.has_method("take_damage"):
		print("[damage] incoming damage: " , str(damage), ".")
		damage = GameManager.process_effect_value(damage , stack_effect.effector.damage)
		print("[damage] outgoing damage: " , str(damage), " .")
		col.take_damage(damage)
