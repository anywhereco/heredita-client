class_name BrushShapeMap
extends Resource

const DEFAULT = preload("uid://bug42uo2av8i2")

const BRUSH_SIZE_MAX = 10

## All vector2s should be convertable to vector2is without dataloss!!
var circle_shape_map: Dictionary[int, PackedVector2Array]

func _init() -> void:
	if circle_shape_map.size() == 0:
		_bake_shape_map()

func _bake_shape_map() -> void:
	for size: int in range(1, BRUSH_SIZE_MAX+1):
		circle_shape_map.set(size, _calc_circle(size))

func _calc_circle(size: int) -> PackedVector2Array:
	var shape := PackedVector2Array([])
	for y: int in range(-size+1, size):
		for x: int in range(-size+1, size):
			if x*x + y*y < (size-1)*(size-1) + size:
				shape.append(Vector2(x, y))
	return shape

func get_vec2s(size: int) -> PackedVector2Array:
	return circle_shape_map.get(size)

func get_image_pixel_offset() -> Vector2:
	return Vector2(floorf(DEFAULT.get_size().x/2.0), floorf(DEFAULT.get_size().x/2.0))

func get_as_image(size: int, color: Color = Color.WHITE) -> Image:
	@warning_ignore("unsafe_call_argument")
	var image := Image.create_from_data(DEFAULT.get_size().x, DEFAULT.get_size().y, false, DEFAULT.get_format(), DEFAULT.get_data())
	for vec: Vector2 in circle_shape_map.get(size):
		vec += get_image_pixel_offset()
		image.set_pixelv(vec, color)
	return image
