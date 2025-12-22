class_name MapperRoot
extends Node3D

enum Tool {
	BRUSH,
	FILL,
	LINE,
	PICK,
	INSPECT,
	PAN,
	MARKING,
	SELECT
}

var tool := ReactiveInt.new(Tool.BRUSH)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
