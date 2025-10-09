class_name double_damage_effect extends stack_effect

func effect(input , type : effector) -> Variant:
	if type == stack_effect.effector.damage:
		print("[effect] type is damage, doubling damage and returning in: " , str(input), " out: " , str(input * 2))
		return input * 2
	print("[effect] type is NOT damage, returning as is")
	return input
