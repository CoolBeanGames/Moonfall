extends HBoxContainer

@export var pip_scene : PackedScene
@export var spawned_pips : Array[ammo_pip]
@export var gun_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect_signal("weapon_changed",onWeaponChanged)
	SignalBus.connect_signal("update_gun_ui",onUpdateUI)

func onUpdateUI():
	update_gun_label()

func update_gun_label():
	gun_label.text = GameManager.get_data("player_gun").gun_name + "[ " + str(GameManager.get_data("bullets",0)) + "]"

func onWeaponChanged():
	update_gun_label()
	##erase all spawned pips
	if spawned_pips != null and spawned_pips.size() > 0:
		while spawned_pips.size() > 0:
			spawned_pips[0].queue_free()
			spawned_pips.erase(spawned_pips[0])
	var counter : int = 0
	var count : int = GameManager.get_data("player_gun").max_clip_size
	#spawn all the pips
	for i in GameManager.get_data("player_gun").max_clip_size:
		var instance = pip_scene.instantiate()
		add_child(instance)
		var p : ammo_pip = instance as ammo_pip
		var type : ammo_pip.PIPTYPE = ammo_pip.PIPTYPE.MIDDLE
		if counter == 0:
			type = ammo_pip.PIPTYPE.LEFT
		if counter == count-1:
			type = ammo_pip.PIPTYPE.RIGHT
		p.setup(type,GameManager.get_data("player_gun"),counter)
		counter += 1
		spawned_pips.append(p)
	
