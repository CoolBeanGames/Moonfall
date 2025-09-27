class_name zombie_hurt_state extends State

##called once when entering the state and then not again until it has finished
func on_enter():
	var character_bb : blackboard = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb._get("anim")
	anim.play("anim/hurt")

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass

