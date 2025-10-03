class_name zombie_spawn_state extends State

##called once when entering the state and then not again until it has finished
func on_enter():
	var character_bb : blackboard = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb.get_data("anim")
	anim.play("anim/land")
	GameManager.set_data("zombie_count",GameManager.get_data("zombie_count",0) + 1)