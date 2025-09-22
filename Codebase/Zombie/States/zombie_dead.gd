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
	state_machine.bb._set("end_process",true)
	GameManager.data.set_data("score",GameManager.data.get_data("score",0) + 1)
	SignalBus.signals.signals["update_score"].event.emit()
	GameManager.data._set("zombie_count",GameManager.data._get("zombie_count") - 1)

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
