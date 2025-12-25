extends CharacterBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var map: Map = $"../Map"

const SPEED = 5.0
const SPRINT_MULT = 3.0
const JUMP_VELOCITY = 4.5

var was_on_floor_last_frame: bool = false

func setup_velocity(direction: Vector3, delta: float) -> void:
	var target_vel := direction * SPEED * (SPRINT_MULT if Input.is_key_pressed(KEY_SHIFT) else 1.0)
	var clock: float
	if direction:
		clock = -60 if is_on_floor() else -40
		direction *= SPEED
	else:
		clock = -25 if is_on_floor() else -15
		
	var weight: float = 1.0 - exp(clock * delta)
	
	var horizontal_vel := Vector2(velocity.x, velocity.z)
	var horizontal_target := Vector2(target_vel.x, target_vel.z)
	var dist_sq := horizontal_vel.distance_squared_to(horizontal_target)
	
	# If we are very close to the target, snap to it to avoid infinite tiny calculations
	if dist_sq < 0.002:
		velocity.x = target_vel.x
		velocity.z = target_vel.z
	else:
		velocity.x = lerp(velocity.x, target_vel.x, weight)
		velocity.z = lerp(velocity.z, target_vel.z, weight)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("jump") and is_on_floor()) or \
	(Input.is_action_pressed("jump") and is_on_floor() and not was_on_floor_last_frame):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, camera_pivot.rotation.y).normalized()
	
	setup_velocity(direction, delta)
	
	var pos2: Vector2 = Vector2(position.x, position.z)
	
	if not map.map_world_bounds.has_point(pos2):
		if not map.map_world_bounds.has_point(Vector2(position.x, 0)):
			position.x = -position.x
			camera_pivot.position = position
		#if not map.map_world_bounds.has_point(Vector2(0, position.z)):
		#	position.z = -position.z
		
	move_and_slide()
