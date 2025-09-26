##a class that defines the logic for a gun
##this handles what actually happens when shooting
##a gun
class_name pistol_strategy extends gun_strategy

func equip(...params : Array):
	update_ui()
	pass

func unequip(...params : Array):
	pass

func shoot(...params : Array):
	params[3].play("shoot_gun")
	params[0].loaded_bullets -= 1
	var raycaster : RayCast3D = params[4] as RayCast3D
	if raycaster.is_colliding() and raycaster.get_collider(): 
		do_damage(params[0],raycaster.get_collider())
	update_ui()

func reload(...params : Array):
	params[1].play("reload_gun")
	update_ui()

func melee(...params : Array):
	params[2].play("melee")


func do_damage(gun_data : gun, col : CollisionObject3D):
	#calcualte the damage
	var damage : int = 0
	if col.is_in_group("BodyShotZone"):
		print("bodyShot")
		damage = gun_data.bullet_damage
		col = col.z
	if col.is_in_group("HeadShotZone"):
		print("headshot")
		damage = gun_data.bullet_damage * 2
		col = col.z
	if col.is_in_group("crate"):
		damage = 0
		print("crate")
	if col.is_in_group("target"):
		damage = 0
		print("target")
	
	#deal the damage we calculated
	if col.has_method("take_damage"):
		print("taking damage")
		col.take_damage(damage)
	else:
		print("collider does not take damage")
