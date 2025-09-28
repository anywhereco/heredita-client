extends Sprite2D

func _ready() -> void:
	State.root_window_moved_or_resized.connect(rescale)

func rescale() -> void:
	scale = Vector2(State.stretch_scale, State.stretch_scale)
