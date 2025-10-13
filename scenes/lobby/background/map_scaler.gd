extends Sprite2D

func _ready() -> void:
	State.stretch_scale.value_changed.connect(rescale)

func rescale(_scale: ReactiveFloat) -> void:
	scale = Vector2(_scale.value, _scale.value)
