class_name Map
extends Node3D

const CHUNK_SIZE: int = 256

@export_range(1.0/16, 1, 1.0/16) var pixel_size: float = 1.0/8

@onready var mapper: MapperRoot = $".."
@onready var player_camera: Camera3D = $"../LocalPlayer/CameraPivot/CameraArm/PlayerCamera"

@onready var chunk_container_node: Node3D = $MapChunks

var map_pos: ReactiveVector2 = ReactiveVector2.new(Vector2.INF)
## Array[Array[bool]], x,y/z order
var chunks_edited: Array[Array] = []
## Array[Array[Sprite3D]], x,y/z order
var chunks: Array[Array] = []

var original_map: Image = preload("uid://do2qcumlvx0lo")
var original_map_size: Vector2

func is_in_bounding_box(test_point: Vector2, min_corner: Vector2, max_corner: Vector2) -> bool:
	return (test_point.x >= min_corner.x and 
			test_point.x <= max_corner.x and
			test_point.y >= min_corner.y and
			test_point.y <= max_corner.y)

func world_space_to_map_space(world_pos: Vector2) -> Vector2:
	world_pos *= 1/pixel_size
	world_pos += (original_map_size/2)
	return world_pos
	
func map_space_to_world_space(_map_pos: Vector2) -> Vector2:
	_map_pos -= (original_map_size/2)
	_map_pos *= pixel_size
	return _map_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_map_size = original_map.get_size()
	for x: int in range(0, original_map_size.x, CHUNK_SIZE):
		for y: int in range(0, original_map_size.y, CHUNK_SIZE):
			@warning_ignore("integer_division")
			var x_idx := x/CHUNK_SIZE
			@warning_ignore("integer_division")
			var y_idx := y/CHUNK_SIZE
			var chunk_coords := Rect2i(Vector2i(x,y), Vector2i(CHUNK_SIZE, CHUNK_SIZE))
			var img := Image.create_empty(CHUNK_SIZE, CHUNK_SIZE, false, original_map.get_format())
			img.blit_rect(original_map, chunk_coords, Vector2i.ZERO)
			var chunk := Sprite3D.new()
			chunk.texture = ImageTexture.create_from_image(img)
			chunk.axis = Vector3.Axis.AXIS_Y
			chunk.double_sided = false
			var center := map_space_to_world_space(Vector2(x+128, y+128))
			chunk.position = Vector3(center.x, 0, center.y)
			chunk.name = "MapChunk%d:%d" % [x, y]
			chunk.pixel_size = pixel_size
			chunk.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
			chunk_container_node.add_child(chunk)
			if chunks.size() <= x_idx:
				chunks.append([])
				chunks_edited.append([])
			chunks.get(x_idx).insert(y_idx, chunk)
			chunks_edited.get(x_idx).insert(y_idx, chunk)
			
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		var mouse_position := get_window().get_mouse_position()
		# The map is at zero on the Y axis
		var intersect: Variant = Plane.PLANE_XZ.intersects_ray(
			player_camera.project_ray_origin(mouse_position),
			player_camera.project_ray_normal(mouse_position)
		)
		if intersect is not Vector3:
			return
		@warning_ignore("unsafe_call_argument")
		var intersect_pos: Vector2 = Vector2(intersect.x, intersect.z)
		map_pos.value = world_space_to_map_space(intersect_pos)
		if not is_in_bounding_box(map_pos.value, Vector2.ZERO, original_map_size):
			return
		@warning_ignore("unused_variable")
		var map_pos_int := Vector2i(map_pos.value)
