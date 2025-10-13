class_name Map
extends Sprite2D

@onready var mapper: MapperRoot = $".."

@warning_ignore("unused_signal")
signal hovering(pos: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
