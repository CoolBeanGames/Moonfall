##a class that defines the logic for a gun
##this handles what actually happens when shooting
##a gun
@abstract
class_name gun_strategy extends Resource

@abstract func equip(...params : Array)
@abstract func unequip(...params : Array)
@abstract func shoot(...params : Array)
@abstract func reload(...params : Array)
@abstract func melee(...params : Array)

func update_ui():
    SignalBus.fire_signal("update_gun_ui")