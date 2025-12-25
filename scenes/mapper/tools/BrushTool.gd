class_name BrushTool
extends Resource

var size: int = 1
var shape: BrushShapeMap = BrushShapeMap.new()
var is_painting: bool = false
var paint_color: Color = Color.WHITE
var target_color: Color = Color.WHITE

func _init() -> void:
	pass

func _map_ready() -> void:
	UIRoot._instance.brush_ui.size_controller.brush_size.value_changed.connect(_brush_size_changed.unbind(1))
	_brush_size_changed()
	UIRoot._instance.brush_ui.target_picker.color.value_changed.connect(
		func(color: ReactiveColor) -> void:
			target_color = color.value
			_update_brush()
	)
	UIRoot._instance.brush_ui.paint_picker.color.value_changed.connect(
		func(color: ReactiveColor) -> void:
			paint_color = color.value
			_update_brush()
	)

func get_image_for_brush() -> Image:
	var image := shape.get_as_image(size)
	var width: int = image.get_width()
	var height: int = image.get_height()

	for y in range(height):
		for x in range(width):
			var pos := Vector2i(Map._instance.map_pos.value - shape.get_image_pixel_offset() + Vector2(x, y))
			var color := Map._instance.get_pixel_at(pos)
			if color.is_equal_approx(target_color) && image.get_pixel(x, y) == Color.WHITE:
				image.set_pixel(x, y, Color.WHITE)
			else:
				image.set_pixel(x, y, Color.TRANSPARENT)
	return image

func brush_events(event: InputEvent) -> void:
	if event.is_action_pressed("pick_paint"):
		var color := Map._instance.get_pixel_at(Map._instance.map_pos.value)
		if color.a == 1:
			UIRoot._instance.brush_ui.paint_picker.color.value = color
	if event.is_action_pressed("pick_target"):
		var color := Map._instance.get_pixel_at(Map._instance.map_pos.value)
		if color.a == 1:
			UIRoot._instance.brush_ui.target_picker.color.value = color
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_painting = true
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_painting = false
	
	if is_painting:
		Map._instance.set_pixels_at_map_pos_targeted(shape.get_vec2s(size), paint_color, target_color)

func _brush_size_changed() -> void:
	size = UIRoot._instance.brush_ui.size_controller.brush_size.value
	_update_brush()

func _update_brush() -> void:
	Map._instance.preview_plane.texture.update(get_image_for_brush())
	var mod := paint_color
	mod.a = 0.5
	Map._instance.preview_plane.modulate = mod
