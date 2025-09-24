extends Label


# In any GDScript file

func _ready():
	var version_number = ProjectSettings.get_setting("application/config/version")
	text = str(version_number)
