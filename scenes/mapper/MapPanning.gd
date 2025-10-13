extends Sprite2D

@onready var mapper: MapperRoot = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pan_dir := Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	if pan_dir != Vector2.ZERO:
		pan(pan_dir * State.stretch_scale.value * delta * 200)
	
func pan(direction: Vector2) -> void:
	direction *= mapper.zoom.value
	position -= direction
