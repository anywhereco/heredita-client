## The game state singleton.
extends Node

@onready var display := DisplayManager.new()

func _ready() -> void:
	add_child(display)
	display.name = "DisplayManager"
