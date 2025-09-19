##this class varies from the standard input actions 
##in that it is for mouse actions
##rather than keys
class_name input_action_mouse extends input_action

func evaluate():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		match state:
			input_state.pressed:
				pressed.emit()
			input_state.idle:
				just_pressed.emit()
				pressed.emit()
				state = input_state.pressed
		is_pressed=true
	else:
		if state == input_state.pressed:
			just_released.emit()
			state = input_state.idle
		is_pressed=false
