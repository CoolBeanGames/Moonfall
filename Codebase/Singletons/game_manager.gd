extends Node

###the data to be stored and accessed system wide
var data : blackboard = blackboard.new()
###the state machine that manages the various game states
var fsm : StateMachine
var zombie_spawners : Array[zombie_spawn_point] = []
var save_data : blackboard = blackboard.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	data.load_from_json("res://config.json")
	#loadin and initialize all data
	fsm = StateMachine.new()
	
	#turn on processing for this node
	set_process(true)
	
	load_save()
	#add transitions to th
	addTransitions()
	addStates()
	fsm.initialize("Preload")
	
	SilentWolf.configure({
	"api_key": "9uvEWuQGEda3DxZ9KLOEy2HZTX4CgbiB25Vz6zTI",
	"game_id": "Moonfall",
	"log_level": 1
	})
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fsm.process()
	data._set("delta",delta)
	pass

##add the states to our machine
func addStates():
	fsm.states["Preload"] = GamePreloadState.new(fsm)
	fsm.states["Splash"] = splash_screen_state.new(fsm)
	fsm.states["Title"] = title_screen_state.new(fsm)
	fsm.states["Game"] = GameState.new(fsm)
	fsm.states["Paused"] = GamePausedState.new(fsm)
	fsm.states["Win"] = GameWinState.new(fsm)
	fsm.states["Lose"] = GameLoseState.new(fsm)
	
	#skip the intro if needed
	if !save_data.has("intro_seen"):
		fsm.states["Intro"] = GameIntroState.new(fsm)
		pass

##called to add the transitions needed for the state machine
func addTransitions():
	#transition for moving from loading to splash screens
	fsm.transitions.append(GameLoadingFinishedTransition.new(fsm,"Splash","Preload"))
	#skip the intro if needed
	if !save_data.has("intro_seen"):
		var e_i : event_transition = event_transition.new("to_intro",fsm,"Intro","Title")
		fsm.transitions.append(e_i)
		var e_g : event_transition = event_transition.new("start_game",fsm,"Game","Intro")
		fsm.transitions.append(e_g)
	fsm.transitions.append(SplashScreenFinishedTransition.new(fsm,"Title","Splash"))
	fsm.transitions.append(game_finished_transition.new(fsm,"Win","Game"))
	var e : event_transition = event_transition.new("new_game_clicked",fsm,"Game","Title")
	fsm.transitions.append(e)
	var e_k : event_transition = event_transition.new("player_killed",fsm,"Lose","Game")
	fsm.transitions.append(e_k)
	var e_t : event_transition = event_transition.new("to_title",fsm,"Title","Lose")
	fsm.transitions.append(e_t)

func save_game():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/save.json"
	save_data.save_to_encrypted_json(path)

func load_save():
	var path : String = "user://CoolBeanGames/MoonFall/Saves/save.json"
	save_data.load_from_encrypted_json(path)
	if save_data.has("player_name"):
		print("player name: ", save_data.get_data("player_name","p"))
