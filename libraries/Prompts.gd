## Library for creating prompt windows.
extends Node

@onready var _window_root = get_node('/root')  

## The override UI.
##
## The override UI is used if you need to have the prompt attached to a specific node.
## If your scene does not have a top-level control, this must be set.
var override_ui: Node

## If the user is currently already in a prompt.
var in_prompt = false

## The prompt the user is in, or null if they are not in a prompt.
var prompt: _Prompt = null

enum PromptCreationResult {
	SUCCESSFUL,
	NO_SUITABLE_UI,
	IN_PROMPT
}

enum PromptActionResult {
	SUCCESSFUL,
	NOT_IN_PROMPT
}

## Returns a Result with the PanelContainer for the Prompt.
func new_fullscreen_prompt(force: bool = false) -> Result:
	if in_prompt and not force:
		return Result.err(PromptCreationResult.IN_PROMPT)
	var prompt_inst = preload("res://libraries/ui/prompt/Prompt.tscn").instantiate()
	var ui = null
	
	if override_ui != null:
		ui = override_ui
	else:
		for child in _window_root.get_children():
			if child is Control: # top-level ui node
				ui = child
				break
	
	if ui == null:
		return Result.err(PromptCreationResult.NO_SUITABLE_UI)
	
	if in_prompt and force:
		prompt.close()
	
	ui.add_child(prompt_inst)
	prompt = prompt_inst.get_child(0).get_child(0)
	return Result.ok(prompt)

## Hides the prompt and returns it in a Result.
func hide_prompt() -> Result:
	if not in_prompt:
		return Result.err(PromptActionResult.NOT_IN_PROMPT)
	prompt.hide_prompt()
	return Result.ok(prompt)
	
## Shows the prompt and returns it in a Result.
func show_prompt() -> Result:
	if not in_prompt:
		return Result.err(PromptActionResult.NOT_IN_PROMPT)
	prompt.show_prompt()
	return Result.ok(prompt)
	
## Closes the prompt.
func close_prompt() -> PromptActionResult:
	if not in_prompt:
		return PromptActionResult.NOT_IN_PROMPT
	prompt.close()
	return PromptActionResult.SUCCESSFUL
	
