class_name Player
extends CSGSphere3D

@onready var camera_pivot: Node3D = $"../CameraPivot"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if not Input.is_key_pressed(KEY_SHIFT):
		self.rotation.y += (camera_pivot.rotation.y - rotation.y) * (1 - exp(-20*delta))
