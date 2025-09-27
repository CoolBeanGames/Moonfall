class_name score_display_ui extends Control

@export var entry_container : Control

func _ready() -> void:
	# Connect to SilentWolf signal
	var sc = SilentWolf.Scores
	sc.sw_get_scores_complete.connect(_on_scores_loaded)

func show_score_ui() -> void:
	# Trigger loading scores (async)
	SilentWolf.Scores.get_scores()

func _on_scores_loaded(scores_data: Dictionary) -> void:
	var scores = scores_data.scores
	print("Scores loaded: ", scores)

	var counter : int = 0
	for c in entry_container.get_children():
		if counter != 0 and c is score_entry:
			var sc : score_entry = c as score_entry
			sc._number = counter
			if scores.size() >= counter:
				sc._name = scores[counter-1]["player_name"]
				sc._score = scores[counter-1]["score"]
			else:
				sc._name = "------"
				sc._score = 0
		counter += 1
