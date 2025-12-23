extends Control

@onready var label: Label = $Label

var original_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label.text.replace("!VER", ProjectSettings.get_setting("application/config/version"))
	original_text = label.text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = original_text % [Engine.get_frames_per_second()]
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F3:
			self.visible = not self.visible
