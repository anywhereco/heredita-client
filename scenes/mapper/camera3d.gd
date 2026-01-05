extends Camera3D

@export_range(0.0, 1.0) var mouse_sensitivity := 0.01
@export var tilt_limit := deg_to_rad(75)

@onready var camera_arm: SpringArm3D = $".."
@onready var camera_pivot: Node3D = $"../.."
@onready var player: CharacterBody3D = $"../../.."

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if (event.button_mask & (MOUSE_BUTTON_MASK_RIGHT | MOUSE_BUTTON_MASK_MIDDLE)) != 0:
			@warning_ignore("unsafe_call_argument")
			camera_pan(event)
			VirtualMouse._instance.set_action(VirtualMouse.Action.PANNING)
		else:
			VirtualMouse._instance.set_action(VirtualMouse.Action.DEFAULT)
	
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		pass
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("zoom_out"):
		camera_arm.spring_length = minf(50, camera_arm.spring_length * 1.1)
	elif event.is_action_pressed("zoom_in"):
		camera_arm.spring_length = maxf(2.5, camera_arm.spring_length * (1/1.1))

func camera_pan(event: InputEventMouseMotion) -> void:
	camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
	# Prevent the camera from rotating too far up or down.
	camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -tilt_limit, tilt_limit)
	camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
