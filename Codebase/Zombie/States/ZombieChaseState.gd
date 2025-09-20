class_name zombie_chase_state extends State

var plr : Node3D
var agent : NavigationAgent3D
var zom : CharacterBody3D
var character_bb : blackboard

##called once whe entering the state and then not again until it has finished
func on_enter():
	print("chase")
	character_bb = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb._get("anim")
	agent = character_bb._get("agent")
	anim.play("anim/run")
	
	plr = GameManager.data._get("player") as Node3D
	zom = character_bb._get("zombie") 

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	var space_state = zom.get_world_3d().direct_space_state
	
	# Check line of sight
	var query = PhysicsRayQueryParameters3D.create(zom.global_position, plr.global_position)
	query.exclude = [zom]
	var result = space_state.intersect_ray(query)
	
	var direction : Vector3
	
	if result.is_empty():
		# ✅ Direct chase
		direction = (plr.global_position - zom.global_position).normalized()
	else:
		# ✅ Navmesh chase
		agent.target_position = plr.global_position
		if not agent.is_navigation_finished():
			var next_path_pos = agent.get_next_path_position()
			direction = (next_path_pos - zom.global_position).normalized()
		else:
			direction = Vector3.ZERO
	
	# Smooth turning (avoid zigzagging)
	if direction != Vector3.ZERO:
		var turn_speed = character_bb._get("turn_speed")
		print(character_bb.data)
		direction = zom.transform.basis.z.lerp(direction, turn_speed).normalized()
		
		# Movement & facing
		zom.velocity = direction * character_bb._get("move_speed")
		zom.look_at(zom.global_position + direction, Vector3.UP)
	
	zom.move_and_slide()
