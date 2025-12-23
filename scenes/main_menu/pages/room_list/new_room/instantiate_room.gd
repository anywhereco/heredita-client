extends Button

const NEW_ROOM_PROMPT = preload("uid://faj2phk4p8di")


func _pressed() -> void:
	var prompt_res := Prompts.new_fullscreen_prompt()
	if prompt_res.is_err():
		return
	var prompt: PromptInstance = prompt_res.val()
	prompt.add_child(NEW_ROOM_PROMPT.instantiate())
