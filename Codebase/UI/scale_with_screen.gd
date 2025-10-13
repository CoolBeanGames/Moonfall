extends Control

@onready var texture_rect = $TextureRect

func _ready():
	_update_layout()
	get_viewport().size_changed.connect(_update_layout)

func _update_layout():
	var screen_size = get_viewport_rect().size
	var viewport_tex = texture_rect.texture

	if viewport_tex == null:
		return

	var tex_size = viewport_tex.get_size()
	if tex_size.y == 0:
		return

	var target_aspect = tex_size.x / tex_size.y
	var screen_aspect = screen_size.x / screen_size.y
	var new_size = Vector2()

	if screen_aspect > target_aspect:
		# Screen is wider → fill vertically, pillarbox sides
		new_size.y = screen_size.y
		new_size.x = screen_size.y * target_aspect
	else:
		# Screen is taller → fill horizontally, letterbox top/bottom
		new_size.x = screen_size.x
		new_size.y = screen_size.x / target_aspect

	# Center horizontally and vertically (top + bottom anchored visually)
	texture_rect.size = new_size
	texture_rect.position = (screen_size - new_size) / 2.0
