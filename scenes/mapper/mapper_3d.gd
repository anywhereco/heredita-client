class_name MapperRoot
extends Node3D

enum Tool {
	NONE,
	BRUSH,
	FILL,
	LINE,
	PICK,
	INSPECT,
	PAN,
	MARKING,
	SELECT
}

static var _instance: MapperRoot

var tool := ReactiveInt.new(Tool.NONE)

func _init() -> void:
	_instance = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func process_tool_use(event: InputEvent, map: Map) -> void:
	match tool.value:
		Tool.NONE:
			return
		Tool.BRUSH:
			if event.is_action_pressed("pick_paint"):
				pass
		_:
			push_error("Tool \"%s\" doesn't have code to handle events!" % MapperRoot.Tool.keys()[tool.value].to_lower())
			return
