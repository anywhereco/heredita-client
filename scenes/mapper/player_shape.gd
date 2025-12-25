extends CSGSphere3D

@onready var player: CharacterBody3D = $".."

var last_vel := Vector2.ZERO
var angle_offset := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var vel := Vector2(player.velocity.x, player.velocity.z)
	if abs(vel.angle() - last_vel.angle()) > PI:
		if signf((vel - last_vel).angle()) == 1:
			angle_offset -= TAU
		else:
			angle_offset += TAU
			
	var angle := vel.angle() + angle_offset

	if vel.length_squared() > 0.05:
		rotation.y += (((angle * -1) + deg_to_rad(-90)) - rotation.y) * (1 - exp(-20*delta))
		last_vel = vel
