## The game state singleton.
extends Node

@onready var display := DisplayManager.new()

@onready var user_settings := UserSettingsManager.new()

@onready var threading := ThreadingManager.new()

var client: InfernoSocketClient = null

var user: User = null

func _ready() -> void:
	add_child(display)
	display.name = "DisplayManager"
	add_child(user_settings)
	user_settings.name = "UserSettingsManager"
