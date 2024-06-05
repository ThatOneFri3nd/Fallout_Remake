extends CharacterBody3D

@export_category("Camera Rotation")
@export var mouse_sens: float = 20
@export var rotate_acceleration: float = 15
@export var rotate_friction: float = 10
@export_category("Camera Movement")
@export var camera_acceleration: float = 15
@export var max_camera_speed: float = 50
@export var camera_friction: float = 10

var movement_vector := Vector3.ZERO
var rotation_speed: float = 0.0
var zoom_level: float = 10.0
var viewport_minimum: float = 200
var viewport_resolution_variance = 600
var viewport_resolution: Vector2

signal rotating_camera

var camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	camera = find_child("Camera3D")
	if camera == null:
		printerr("Camera not found! Make sure Camera3D is a child of Camera!")
		return
	viewport_resolution.x = (camera.size / 100) * viewport_resolution_variance
	viewport_resolution.y = (camera.size / 100) * viewport_resolution_variance


func _input(event):
	if Input.is_action_pressed("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		emit_signal("rotating_camera")
		if event is InputEventMouseMotion:
			var speed = Input.get_last_mouse_velocity().x * (mouse_sens / 100000)
			rotation_speed += speed * rotate_acceleration
		elif Input.is_action_just_released("camera_rotate"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_released("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		if Input.is_action_just_released("camera_zoom_out"):
			pass
		elif Input.is_action_just_released("camera_zoom_in"):
			pass


func _process(delta):
	var xz_input = Vector3.ZERO
	xz_input.z = Input.get_axis("camera_forward", "camera_backward")
	xz_input.x = Input.get_axis("camera_left", "camera_right")
	
	xz_input = xz_input.limit_length(1.0)
	xz_input *= max_camera_speed
	xz_input.y = 0 # Maintain the y component at 0 to avoid vertical movement
	
	if xz_input.length() > 0:
		movement_vector = movement_vector.move_toward(xz_input, camera_acceleration * delta)
	else:
		movement_vector = movement_vector.move_toward(Vector3.ZERO, camera_friction * delta)
	translate(movement_vector * delta)
	
	# Handle camera rotation with friction
	if Input.is_action_pressed("camera_rotate"):
		rotation_speed = lerp(rotation_speed, float(0), rotate_friction * delta)
		rotate_y(rotation_speed * delta)
	else:
		rotation_speed = lerp(rotation_speed, float(0), rotate_friction * delta)
		if abs(rotation_speed) > 0.01: # small threshold to stop tiny rotations
			rotate_y(rotation_speed * delta)
		else:
			rotation_speed = 0.0
			
