extends PanelContainer
class_name PromptInstance

signal prompt_closed

var idx := -1

@onready
var blur: ColorRect = self.get_parent().get_parent() as ColorRect

func _input(event: InputEvent) -> void:
	var mouseEvent := event as InputEventMouseButton
	if mouseEvent is InputEventMouseButton and mouseEvent.is_pressed() and mouseEvent.button_index == 1:
		var evLocal := make_input_local(mouseEvent) as InputEventMouseButton
		if idx == Prompts.prompts.size() - 1 and not Prompts.prompt_already_closed and not Rect2(Vector2(0,0), size).has_point(evLocal.position):
			close()

func close() -> void:
	Prompts.prompt_already_closed = true
	prompt_closed.emit()
	blur.queue_free()
	if Prompts.prompts.size() <= 1:
		Prompts.in_prompt = false
	Prompts.prompts.remove_at(idx)

func hide_prompt() -> void:
	blur.hide()

func show_prompt() -> void:
	blur.show()
