extends Node

###the data to be stored and accessed system wide
var data : blackboard = blackboard.new()
###the state machine that manages the various game states
var fsm : StateMachine

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#wait one frame
	#await get_tree().process_frame
	
	#loadin and initialize all data
	#fsm = StateMachine.new()
	
	#turn on processing for this node
	#set_process(true)
	
	#add transitions to th
	#addTransitions()
	#addStates()
	#fsm.initialize("Preload")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#fsm.process()

##add the states to our machine
func addStates():
	fsm.states["Preload"] = GamePreloadState.new(fsm)
	fsm.states["Splash"] = splash_screen_state.new(fsm)
	fsm.states["Title"] = title_screen_state.new(fsm)
	fsm.states["Game"] = GameWinState.new(fsm)
	fsm.states["Paused"] = GamePausedState.new(fsm)
	fsm.states["Win"] = GameWinState.new(fsm)
	fsm.states["Lose"] = GameLoseState.new(fsm)

##called to add the transitions needed for the state machine
func addTransitions():
	#transition for moving from loading to splash screens
	fsm.transitions.append(GameLoadingFinishedTransition.new(fsm,"Splash","Preload"))
	fsm.transitions.append(SplashScreenFinishedTransition.new(fsm,"Title","Splash"))
