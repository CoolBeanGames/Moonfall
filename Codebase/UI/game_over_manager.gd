extends Node2D

@export var insert_name_ui : Control
@export var name_field : LineEdit
@export var score_display : score_display_ui


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !GameManager.save_data.data.has("player_name"):
		GameManager.save_data.data.set("player_name","player_" + str(randi()))
	name_field.text = GameManager.save_data.data.get("player_name","player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_name_entry():
	if name_field.text != "" and name_field.text != " ":
		GameManager.save_data.data["player_name"] = name_field.text
		var score = GameManager.data.data.get("score",0) +1
		await SilentWolf.Scores.save_score(name_field.text,score)
		await GameManager.save_game()
		score_display.visible = true
		await score_display.show_score_ui()
		insert_name_ui.queue_free()

func on_back_to_title():
	SignalBus.fire_signal("to_title")
