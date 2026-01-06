class_name VirtualMouse
extends Sprite2D

enum Action {
	DEFAULT,
	BRUSH,
	PANNING
}

const ACTION_TEX_MAP: Dictionary[Action, Texture2D] = {
	Action.DEFAULT: preload("uid://dmqeubohwubs"),
	Action.BRUSH: preload("uid://c5cl8n3npd8bn"),
	Action.PANNING: preload("uid://byfqo6a6v6gvn")
}

const ACTION_OFFSET_MAP: Dictionary[Action, Vector2] = {
	Action.DEFAULT: Vector2(8, 12),
	Action.BRUSH: Vector2(12, 12),
	Action.PANNING: Vector2(0, 0)
}

const VIRTUAL_MOUSE_DEVICE := 7


static var _instance: VirtualMouse 


var action: Action = Action.DEFAULT
var tool_action: Action = Action.DEFAULT


func _init() -> void:
	_instance = self

func set_action(new_action: Action) -> void:
	texture = ACTION_TEX_MAP[new_action]
	offset = ACTION_OFFSET_MAP[new_action]
	action = new_action
	
func set_action_tool(new_action: Action) -> void:
	tool_action = new_action
	texture = ACTION_TEX_MAP[tool_action]
	offset = ACTION_OFFSET_MAP[tool_action]
	action = tool_action

func _ready() -> void:
	position = get_local_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouse and event.device != VIRTUAL_MOUSE_DEVICE:
			if event is InputEventMouseMotion and action != Action.PANNING:
				position = position + event.relative
				if not get_viewport().get_visible_rect().has_point(global_position):
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				var virtual_event: InputEventMouseMotion = InputEventMouseMotion.new()
				virtual_event.relative = event.relative
				virtual_event.position = get_viewport().get_screen_transform() * position
				virtual_event.button_mask = event.button_mask
				virtual_event.device = VIRTUAL_MOUSE_DEVICE
				get_viewport().set_input_as_handled()
				Input.parse_input_event(virtual_event)
			elif event is InputEventMouseButton:
				var virtual_event: InputEventMouseButton = InputEventMouseButton.new()
				virtual_event.position = get_viewport().get_screen_transform() * position
				virtual_event.button_index = event.button_index
				virtual_event.pressed = event.pressed
				virtual_event.button_mask = event.button_mask
				virtual_event.device = VIRTUAL_MOUSE_DEVICE
				get_viewport().set_input_as_handled()
				Input.parse_input_event(virtual_event)

	else:
		if event is InputEventMouseButton and event.pressed:
			global_position = get_global_mouse_position()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
