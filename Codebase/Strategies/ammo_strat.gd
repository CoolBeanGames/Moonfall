##strategy that adds ammo
class_name ammo_strategy extends strategy

@export var min_gained : int
@export var max_gained : int

##call to add ammo to the player
func execute(..._params):
	var ammount_gained : int = randi_range(min_gained,max_gained)
	GameManager.data.set_data("bullets",GameManager.data.get_data("bullets",0) + ammount_gained)
	SignalBus.signals.signals["update_gun_ui"].event.emit()
