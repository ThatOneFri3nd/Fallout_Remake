extends CharacterBody3D

#Exported pass-by-value variables
@export_category("Camera Rotation")
@export_range(0, 100, 0.1) var mouse_sens: float = 20
@export_range(0, 100, 0.1) var rotate_acceleration: float = 15
@export_range(0, 100, 0.1) var rotate_friction: float = 10
@export_category("Camera Movement")
@export_range(0, 100, 0.1) var camera_acceleration: float = 15
@export_range(0, 100, 0.1) var max_camera_speed: float = 50
@export_range(0, 100, 0.1) var camera_friction: float = 10
@export_category("Camera Zoom")
@export_range(0, 100, 0.1) var min_zoom: float = 90
@export_range(0, 100, 0.1) var max_zoom: float = 10
@export_range(0, 100, 0.1) var zoom_speed_percentage: float = 10
@export_range(0, 100, 0.1) var zoom_sharpness: float = 50

#Non-exported pass-by-reference variables
@onready var camera: Camera3D = find_child("Camera3D")

#Non-exported pass-by-value variables
var movement_vector := Vector3.ZERO
var rotation_speed: float = 0.0
var current_zoom: float = 0.5
@onready var zoom_speed: float = zoom_speed_percentage / 100

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if camera == null:
		printerr("Camera not found! Make sure Camera3D is a child of Camera!")
		return


func _input(event):
	if Input.is_action_pressed("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			var speed = Input.get_last_mouse_velocity().x * (mouse_sens / 100000)
			rotation_speed += speed * rotate_acceleration
		elif Input.is_action_just_released("camera_rotate"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_released("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		if Input.is_action_just_released("camera_zoom_in"):
			current_zoom += zoom_speed
		elif Input.is_action_just_released("camera_zoom_out"):
			current_zoom -= zoom_speed
		current_zoom = clamp(current_zoom, 0, 1)

func _process(delta):
	move_camera(delta)
	rotate_camera(delta)
	zoom_camera(delta)

func move_camera(delta: float):
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

func rotate_camera(delta: float):
	if Input.is_action_pressed("camera_rotate"):
		rotation_speed = lerp(rotation_speed, float(0), rotate_friction * delta)
		rotate_y(rotation_speed * delta)
	else:
		rotation_speed = lerp(rotation_speed, float(0), rotate_friction * delta)
		if abs(rotation_speed) > 0.01: # small threshold to stop tiny rotations
			rotate_y(rotation_speed * delta)
		else:
			rotation_speed = 0.0

func zoom_camera(delta: float):
	var camera_distance = lerp(min_zoom, max_zoom, current_zoom)
	camera.position = linear_follow(camera.position, camera.position.normalized() * camera_distance, delta)
	#This is not frame-rate independent

func linear_follow(a, b, delta: float):
	return b + (a - b) * exp(-zoom_sharpness * delta)
