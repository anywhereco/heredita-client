## The game state singleton.
extends Node

## If the root window was just moved or resized.
signal root_window_moved_or_resized()

## The default viewport size.
const DEFAULT_VIEWPORT_SIZE: Vector2 = Vector2(720, 480)

## The root window's script.
const ROOT_WINDOW_SCRIPT: Script = preload("res://singletons/state/window_notification_handling.gd")

## The display server's scale.
## The content scale factor is set to this when the program first runs.
@onready var display_server_scale: float = DisplayServer.screen_get_scale(DisplayServer.SCREEN_OF_MAIN_WINDOW)

## The root window.
@onready var root_window: Window = get_tree().root

## The scale relative to the default viewport size after scale adjustment.
## Warning: Do not use this scale for most things; only use it if you need an assured size for something nonessential.
@onready var stretch_scale: float = _calculate_stretch_scale()

func _ready() -> void:
	root_window.set_script(ROOT_WINDOW_SCRIPT)
	print(stretch_scale)
	root_window.content_scale_factor = display_server_scale

func _calculate_stretch_scale() -> float:
	var adjusted_resolution := root_window.size / display_server_scale
	
	var scale_x := adjusted_resolution.x / DEFAULT_VIEWPORT_SIZE.x
	var scale_y := adjusted_resolution.y / DEFAULT_VIEWPORT_SIZE.y
	
	return scale_x if scale_x > scale_y else scale_y

func _root_window_notifications(notif: int) -> void:
	match notif:
		NOTIFICATION_WM_POSITION_CHANGED, NOTIFICATION_WM_SIZE_CHANGED:
			_root_window_rescaled_or_moved()

func _root_window_rescaled_or_moved() -> void:
	var prev_display_scale := display_server_scale
	display_server_scale = DisplayServer.screen_get_scale(DisplayServer.SCREEN_OF_MAIN_WINDOW)
	if prev_display_scale != display_server_scale:
		root_window.content_scale_factor = display_server_scale
	stretch_scale = _calculate_stretch_scale()
	root_window_moved_or_resized.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
