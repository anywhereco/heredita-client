class_name VirtualMouse
extends Sprite2D

static var _instance: VirtualMouse 

const VIRTUAL_MOUSE_DEVICE := 7

var panning: bool = false

func _init() -> void:
	_instance = self

func set_panning(val: bool) -> void:
	panning = val
	visible = not val

func _ready() -> void:
	position = get_local_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouse and event.device != VIRTUAL_MOUSE_DEVICE:
			if event is InputEventMouseMotion and not panning:
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
			
