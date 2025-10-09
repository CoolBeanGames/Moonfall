class_name player_shield_effect extends stack_effect

func effect(input , type : effector) -> Variant:
	if type == stack_effect.effector.player_damage:
		return 0
	return input
