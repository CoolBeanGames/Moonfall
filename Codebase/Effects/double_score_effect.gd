class_name double_score_effect extends stack_effect

func effect(input , type : effector) -> Variant:
	if type == stack_effect.effector.score:
		return input * 2
	return input
