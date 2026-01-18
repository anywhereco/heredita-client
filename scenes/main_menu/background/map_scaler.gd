extends Sprite2D

func _ready() -> void:
	State.display.stretch_scale.value_changed.connect(rescale)
	rescale(State.display.stretch_scale)

func rescale(_scale: ReactiveFloat) -> void:
	scale = Vector2(_scale.value, _scale.value)
