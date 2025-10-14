class_name ammo_pip extends TextureRect

enum PIPTYPE{LEFT,RIGHT,MIDDLE}
enum PIPSTATE{EMPTY,FULL}

@export var pip_type : PIPTYPE = PIPTYPE.MIDDLE
@export var pip_state : PIPSTATE = PIPSTATE.FULL
@export var textures : Dictionary[String,Texture] = {}
@export var gun_for_pip : gun
@export var bullet_index : int

func setup(type : PIPTYPE, gundata : gun, index : int):
	self.gun_for_pip = gundata
	self.bullet_index = index
	self.pip_type = type
	
	#set the texture
	check_ammo()
	set_tex()
	
	SignalBus.connect_signal("update_gun_ui",update_pip)

func update_pip():
	var entry_state : PIPSTATE = pip_state
	check_ammo()
	if pip_state != entry_state:
		set_tex()

func check_ammo():
	if gun_for_pip.loaded_bullets > bullet_index:
		pip_state = PIPSTATE.FULL
	else:
		pip_state = PIPSTATE.EMPTY

func set_tex():
	var key : String
	var state : String
	
	if pip_state == PIPSTATE.EMPTY:
		state = "empty"
	else:
		state = "full"
	
	match pip_type:
		PIPTYPE.LEFT:
			key = "left_" + state
		PIPTYPE.MIDDLE:
			key = "mid_" + state
		PIPTYPE.RIGHT:
			key = "right_" + state
	
	texture = textures[key]
