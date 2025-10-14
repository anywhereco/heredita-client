class_name MapCamera
extends Camera2D

@onready var mapper: MapperRoot = $".."

var wanted_position := Vector2.ZERO

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	var pan_dir := Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	if pan_dir != Vector2.ZERO:
		camera_pan(pan_dir * State.display.stretch_scale.value * delta * 600 / mapper.base_zoom.value)
	var zoom_intensity := 0
	zoom_intensity += 1 if Input.is_action_just_pressed("zoom_up") else 0
	zoom_intensity -= 1 if Input.is_action_just_pressed("zoom_down") else 0
	camera_zoom(zoom_intensity)
	position += (wanted_position - position) * (1 - exp(-40*delta))

func camera_pan(direction: Vector2) -> void:
	direction *= mapper.zoom.value
	wanted_position += direction

const ZOOM_SNAPS := [0.5, 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64]

func camera_zoom(intensity: float) -> void:
	var zoom_to_set := mapper.base_zoom.value
	zoom_to_set *= pow(1.1, intensity)
	if zoom_to_set < 0.125:
		zoom_to_set = 0.125
	if zoom_to_set > 64:
		zoom_to_set = 64
	mapper.base_zoom.value = zoom_to_set
	for snap: float in ZOOM_SNAPS:
		var tol := 0.03 * snap
		var diff := absf(zoom_to_set - snap)
		if diff <= tol:
			zoom_to_set = snap
	mapper.effective_zoom.value = zoom_to_set
	zoom = Vector2(zoom_to_set, zoom_to_set)
