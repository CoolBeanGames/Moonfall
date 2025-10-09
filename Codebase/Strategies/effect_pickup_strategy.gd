class_name effect_pickup_strategy
extends strategy

#the effect we want to add to the stack
@export var effect : stack_effect
#how long the effect should be active for
@export var active_time : float

#add the effect
func execute(...params):
	GameManager.add_effect(effect,active_time)
