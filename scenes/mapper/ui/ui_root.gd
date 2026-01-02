class_name UIRoot
extends CanvasLayer

static var _instance: UIRoot

@onready var brush_ui: BrushUI = find_child("ToolUIContainer").find_child("brush", false)

func _init() -> void:
	_instance = self
