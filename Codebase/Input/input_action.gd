#holds signals and some values for buttons the user can press
#support for remapping (though i dont know if this will be used)
class_name input_action extends Resource

##the key this input expects as a string
var key : Key
##the current state for this input
var state : input_state = input_state.idle
##simpler way to see if action is firing this frame
var is_pressed : bool = false
##fires the first frame this input is pressed
signal just_pressed
##fires the first frame when this input is released
signal just_released
##fired every frame while this input is pressed
signal pressed

##called every frame to update data for the action
func evaluate():
	if Input.is_physical_key_pressed(key):
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


##holds data for the current state for this action
enum input_state{
	pressed,
	idle
}
