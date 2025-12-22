class_name Player
extends CSGSphere3D

## in m/s
@export_range(0.0, 20.0) var speed := 5
@onready var player_camera: Camera3D = $CameraPivot/CameraArm/PlayerCamera

@onready var player_collision: CharacterBody3D = $PlayerCollision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
