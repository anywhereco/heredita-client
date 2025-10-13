class_name MapperRoot
extends Node2D

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

var zoom := ReactiveFloat.new(1)

var tool := ReactiveInt.new(Tool.BRUSH)

var base_zoom := ReactiveFloat.new(1)
var effective_zoom := ReactiveFloat.new(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
