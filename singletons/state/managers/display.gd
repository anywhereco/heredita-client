class_name DisplayManager
extends Node

## If the root window was just moved or resized.
signal root_window_moved_or_resized()

## The default viewport size.
const DEFAULT_VIEWPORT_SIZE: Vector2 = Vector2(720, 480)

## The root window's script.
const ROOT_WINDOW_SCRIPT: Script = preload("res://singletons/state/window_notification_handling.gd")

## The root window.
@onready var root_window: Window = get_tree().root

## The display server's recommended scale.
@onready var display_server_recommended_scale := ReactiveFloat.new(DisplayServer.screen_get_scale(DisplayServer.SCREEN_OF_MAIN_WINDOW))

## The true scale.
## The content scale factor is set to this.
@onready var scale := ReactiveFloat.new(_calculate_true_scale())

## The scale relative to the default viewport size after scale adjustment.
## Warning: Do not use this scale for most things; only use it if you need an assured size for something nonessential.
@onready var stretch_scale := ReactiveFloat.new(1)

## The scale relative to the default viewport size after scale adjustment, on the axis which is smaller.
## Warning: Do not use this scale for most things; only use it if you need an assured size for something nonessential.
@onready var reduced_stretch_scale := ReactiveFloat.new(1)

## The scale relative to the default viewport size after scale adjustment, on the X axis.
## Warning: Do not use this scale for most things; only use it if you need an assured size for something nonessential.
@onready var stretch_scale_x := ReactiveFloat.new(1)

## The scale relative to the default viewport size after scale adjustment, on the Y axis.
## Warning: Do not use this scale for most things; only use it if you need an assured size for something nonessential.
@onready var stretch_scale_y := ReactiveFloat.new(1)

func _ready() -> void:
	root_window.set_script(ROOT_WINDOW_SCRIPT)
	root_window.content_scale_factor = scale.value
	_calculate_stretch_scales()

func _calculate_true_scale() -> float:
	var adjusted_resolution := root_window.size / display_server_recommended_scale.value
	
	var scale_x := adjusted_resolution.x / DEFAULT_VIEWPORT_SIZE.x
	var scale_y := adjusted_resolution.y / DEFAULT_VIEWPORT_SIZE.y
	
	var temp_scale := scale_x if scale_x < scale_y else scale_y
	if temp_scale < display_server_recommended_scale.value:
		return temp_scale
	return display_server_recommended_scale.value

func _calculate_stretch_scales() -> void:
	var adjusted_resolution := root_window.size / scale.value
	
	var scale_x := adjusted_resolution.x / DEFAULT_VIEWPORT_SIZE.x
	var scale_y := adjusted_resolution.y / DEFAULT_VIEWPORT_SIZE.y
	
	stretch_scale.value = maxf(scale_x, scale_y)
	reduced_stretch_scale.value = minf(scale_x, scale_y)
	stretch_scale_x.value = scale_x
	stretch_scale_y.value = scale_y

func _root_window_notifications(notif: int) -> void:
	match notif:
		NOTIFICATION_WM_POSITION_CHANGED, NOTIFICATION_WM_SIZE_CHANGED:
			_root_window_rescaled_or_moved()

func _root_window_rescaled_or_moved() -> void:
	var prev_scale := scale.value
	scale.value = _calculate_true_scale()
	display_server_recommended_scale.value = DisplayServer.screen_get_scale(DisplayServer.SCREEN_OF_MAIN_WINDOW) 
	if prev_scale != scale.value:
		root_window.content_scale_factor = scale.value
	_calculate_stretch_scales()
	root_window_moved_or_resized.emit()
