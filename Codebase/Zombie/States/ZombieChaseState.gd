class_name zombie_chase_state extends State

var plr : Node3D
var agent : NavigationAgent3D
var zom : CharacterBody3D
var character_bb : blackboard
var recalculation_counter : int = 0
var target_position : Vector3
var direction : Vector3

##called once whe entering the state and then not again until it has finished
func on_enter():
	character_bb = state_machine.bb.data["bb"]
	var anim : AnimationPlayer = character_bb.get_data("anim")
	agent = character_bb.get_data("agent")
	anim.play("anim/run")
	
	plr = GameManager.get_data("player") as Node3D
	zom = character_bb.get_data("zombie") 
	
	recalculation_counter = 0

##called when we exit the state
func on_exit():
	pass

##called every frame for this state
func tick():
	recalculation_counter += 1
	
	var space_state = zom.get_world_3d().direct_space_state
	
	if recalculation_counter >= character_bb.data["path_recalculation_frames"]:
		recalculation_counter = 0
		# Check line of sight
		var query = PhysicsRayQueryParameters3D.create(zom.global_position, plr.global_position)
		query.exclude = [zom,plr]
		var result = space_state.intersect_ray(query)	
		
		if result.is_empty():
			#  Direct chase
			direction = (plr.global_position - zom.global_position).normalized()
		else:
			# Navmesh chase
			agent.target_position = plr.global_position
			if not agent.is_navigation_finished():
				var next_path_pos = agent.get_next_path_position()
				direction = (next_path_pos - zom.global_position).normalized()
			else:
				direction = Vector3.ZERO
	
	# Smooth turning (avoid zigzagging)
	if direction != Vector3.ZERO:
		var turn_speed = character_bb.get_data("turn_speed")
		direction = zom.transform.basis.z.lerp(direction, turn_speed).normalized()
		
		# Movement & facing
		zom.velocity = direction * character_bb.get_data("move_speed")
		zom.look_at(zom.global_position + direction, Vector3.UP)
	zom.velocity.y = 0
	zom.rotation_degrees.x = 0
	zom.rotation_degrees.z = 0
	
	zom.move_and_slide()
