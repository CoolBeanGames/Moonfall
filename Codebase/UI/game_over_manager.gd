extends Node2D

@export var insert_name_ui : Control
@export var name_field : LineEdit
@export var score_display : score_display_ui


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !GameManager.save_data.data.has("player_name"):
		GameManager.save_data.data.set("player_name","player_" + str(randi()))
	GameManager.save_data.data["has_finished_game"] = true
	GameManager.save_game()
	print("saved game :" , str(GameManager.save_data.data.keys()))
	name_field.text = GameManager.save_data.data.get("player_name","player")

	var sc = SilentWolf.Scores
	sc.sw_get_scores_complete.connect(_on_scores_loaded)
	sc.sw_save_score_complete.connect(_on_score_saved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_name_entry():
	if name_field.text.strip_edges() != "":
		GameManager.save_data.data["player_name"] = name_field.text
		var score = GameManager.get_data("score",0)

		await SilentWolf.Scores.save_score(name_field.text, score)
		await GameManager.save_game()		

func _on_score_saved(_sw_result):
	SilentWolf.Scores.get_scores()
		

func _on_scores_loaded(_sw_result):
	score_display.visible = true
	score_display.show_score_ui() # Now just triggers loading

func on_back_to_title():
	GameManager.reset_data()
	SignalBus.fire_signal("to_title")
