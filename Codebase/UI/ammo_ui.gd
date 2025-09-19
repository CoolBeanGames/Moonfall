class_name ammo_ui extends Control

@export var total_ammo : Label
@export var loaded_ammo : Label
@export var gun_name : Label
var player_gun : gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.signals.signals["update_gun_ui"].event.connect(update_ui)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ui():
	print("update ui")
	player_gun = GameManager.data._get("player_gun")
	if player_gun == null:
		return
	total_ammo.text = str(GameManager.data.data.get("bullets",0))
	loaded_ammo.text = str(player_gun.loaded_bullets) + " / " + str(player_gun.max_clip_size)
