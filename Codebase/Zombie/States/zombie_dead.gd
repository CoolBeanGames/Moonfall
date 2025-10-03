class_name zombie_dead extends State

var plr : Node3D
var agent : NavigationAgent3D
var zom : CharacterBody3D
var character_bb : blackboard


##called once whe entering the state and then not again until it has finished
func on_enter():
	character_bb = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb.get_data("anim")
	agent = character_bb.get_data("agent")
	anim.play("anim/death")	
	zom = character_bb.get_data("zombie") 
	zom.velocity = Vector3.ZERO
	zom.bb.set_data("end_process",true)
	GameManager.set_data("score",GameManager.get_data("score",0) + 1)
	SignalBus.signals.signals["update_score"].event.emit()
	GameManager.set_data("zombie_count",GameManager.get_data("zombie_count") - 1)
	GameManager.get_tree().create_timer(15).timeout.connect(zom.queue_free)

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	pass
