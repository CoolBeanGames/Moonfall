class_name player_roaming extends State

##called once when entering the state and then not again until it has finished
func on_enter():
	await GameManager.get_tree().process_frame
	var player_data : blackboard = state_machine.bb.get_data("player_data")
	player_data.get_data("player_look").setup()
	player_data.get_data("player_move").setup()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


##called when we exit the state
func on_exit():
	state_machine.bb.get_data("player_data").get_data("player_look").unset()
	state_machine.bb.get_data("player_data").get_data("player_move").unset()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

##called every frame for this state
func tick():
	pass
