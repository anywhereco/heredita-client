class_name UIRoot
extends CanvasLayer

static var _instance: UIRoot

@onready var brush_ui: BrushUI = $LeftItems/ToolUI/VBoxContainer/ToolUIContainer/brush

func _init() -> void:
	_instance = self
