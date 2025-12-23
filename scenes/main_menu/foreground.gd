extends CanvasLayer

@onready var switch_element: Control = $SwitchElement

func _ready() -> void:
	Prompts.override_ui = self
