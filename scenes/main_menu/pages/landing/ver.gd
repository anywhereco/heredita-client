extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = text % [ProjectSettings.get_setting("application/config/version")]
