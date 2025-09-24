class_name score_entry extends PanelContainer

@export var entry_num : Label
@export var entry_name : Label
@export var entry_score : Label

@export var _number : int
@export var _name : String
@export var _score : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	entry_name.text = _name
	entry_num.text = str(_number)
	entry_score.text = str(_score)
