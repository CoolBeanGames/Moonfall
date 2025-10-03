class_name zombie_attack_state extends State

var plr : Node3D
var agent : NavigationAgent3D
var zom : CharacterBody3D
var character_bb : blackboard


##called once whe entering the state and then not again until it has finished
func on_enter():
	print("attack")
	character_bb = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb.get_data("anim")
	agent = character_bb.get_data("agent")
	anim.play("anim/attack")	
	zom = character_bb.get_data("zombie") 
	zom.velocity = Vector3.ZERO
	AudioManager.play_audio_file(load("res://Audio/SFX/zombie/zombie_attack.wav"),"zombie_noises",true,zom.global_position)
	#c

##called when we exit the state
func on_exit():
	state_machine.bb.set_data("attack_finished",false)

##called every frame for this state
func tick():
	pass
