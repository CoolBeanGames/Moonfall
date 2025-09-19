class_name player_roaming extends State

##called once when entering the state and then not again until it has finished
func on_enter():
	await GameManager.get_tree().process_frame
	state_machine.bb._get("player_data")._get("player_look").setup()
	state_machine.bb._get("player_data")._get("player_move").setup()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


##called when we exit the state
func on_exit():
	state_machine.bb._get("player_data")._get("player_look").unset()
	state_machine.bb._get("player_data")._get("player_move").unset()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

##called every frame for this state
func tick():
	pass
