extends Camera2D

@export var radius: float = 200.0
@export var seconds_per_loop: float = 1.0
@export var rotation_amount: float = 0.1

var t: float = 0.0

func _process(delta: float) -> void: 
	t += delta * (1/seconds_per_loop) * TAU

	var x = radius * sin(t) * 1.6
	var y = radius * sin(t) * cos(t)

	global_position = Vector2(x, y)

	rotation = sin(t) * rotation_amount
