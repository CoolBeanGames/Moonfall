#this class is used to allow the player to look around
#to use it simple call the setup command
class_name player_look extends Node

#the player body used for looking (horizontally)
@export var plr : player
#the camera used for looking (vertically)
@export var camera : PhantomCamera3D
#the input axis for looking around
@export var look_axis : input_axis
#current x rotation (vertical)
var rot_x : float = 0
#current y rotation (horizontal)
var rot_y : float = 0
#the rotation the player WANTs to be looking at
var target_rot_x : float = 0
#the rotation the player WANTs to be looking at
var target_rot_y : float = 0
#how fast should lerp move towords the target
var lerp_speed : float = 0
#how far up and down can we look
var pitch_clamp : float = 0
#how fast can we look around
var look_speed : float = 0
#delta time for lerping
var delta : float = 0



#get our look axis
func _ready():
	look_axis = InputManager.axis["mouse"]

func _process(_delta):
	delta = _delta
	lerp_rot()
	apply_rot()

#called when entering the roam state
func setup():
	look_axis.context_fired.connect(mouse_moved)

	#set initial rotation so we dont look around
	rot_x = plr.rotation_degrees.x
	rot_y = camera.rotation_degrees.y
	target_rot_x = rot_x
	target_rot_y = rot_y

#called when exiting the roam state
func unset():
	look_axis.context_fired.disconnect(mouse_moved)

#automatically called whenever our mouse is moved
func mouse_moved(value : Vector2):
	pitch_clamp = plr.bb._get("pitch_clamp")
	look_speed = plr.bb.get("look_speed")
	calculate_rot(value)

#calculate our player rotation
func calculate_rot(input : Vector2):
	target_rot_y += (-input.x) * look_speed * delta
	target_rot_x = clamp(target_rot_x + (input.y * look_speed * delta), -pitch_clamp,pitch_clamp)

#apply the camera rotation to the player
func apply_rot():
	plr.rotation_degrees.y = rot_y
	camera.rotation_degrees.x = rot_x

#smooothly lerp the camera to the target
func lerp_rot():
	lerp_speed = plr.bb._get("look_lerp_speed")
	rot_x = lerp(rot_x,target_rot_x, (1-exp(-delta * lerp_speed)))
	rot_y = lerp(rot_y,target_rot_y, (1-exp(-delta * lerp_speed)))
	pass
