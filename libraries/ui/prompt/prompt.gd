extends PanelContainer
class_name PromptInstance

signal prompt_closed

@onready
var blur: ColorRect = self.get_parent().get_parent() as ColorRect

func _input(event: InputEvent) -> void:
	var mouseEvent := event as InputEventMouseButton
	if mouseEvent is InputEventMouseButton and mouseEvent.is_pressed() and mouseEvent.button_index == 1:
		var evLocal := make_input_local(mouseEvent) as InputEventMouseButton
		if not Rect2(Vector2(0,0), size).has_point(evLocal.position):
			close()

func close() -> void:
	prompt_closed.emit()
	blur.queue_free()
	Prompts.in_prompt = false # We set this first so the user knows that if in_prompt is true, there WILL be a prompt in the singleton.
	Prompts.prompt = null

func hide_prompt() -> void:
	blur.hide()

func show_prompt() -> void:
	blur.show()
