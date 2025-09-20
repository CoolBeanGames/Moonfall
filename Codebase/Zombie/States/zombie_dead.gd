class_name zombie_dead extends State

var plr : Node3D
var agent : NavigationAgent3D
var zom : CharacterBody3D
var character_bb : blackboard


##called once whe entering the state and then not again until it has finished
func on_enter():
	print("death")
	character_bb = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb._get("anim")
	agent = character_bb._get("agent")
	anim.play("anim/death")	
	zom = character_bb._get("zombie") 
	zom.velocity = Vector3.ZERO

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass

