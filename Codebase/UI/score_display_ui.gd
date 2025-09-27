class_name score_display_ui extends Control

@export var entry_container : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	show_score_ui()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_score_ui():
	var counter : int = 0
	
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	var scores = sw_result.scores
	print("Scores: " + str(sw_result.scores))
	
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
