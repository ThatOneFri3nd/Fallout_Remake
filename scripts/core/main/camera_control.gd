extends Node3D

@export var mouse_sens: float
@export var camera_acceleration: float
@export var max_camera_speed: float
var camera_speed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var fixed_delta: float = get_physics_process_delta_time()
	if Input.is_action_pressed("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			var speed = Input.get_last_mouse_velocity() * (mouse_sens / 100000)
			self.rotation.y = self.rotation.y + speed.x
	
	if Input.is_action_just_released("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_pressed("camera_forward"):
		camera_speed += camera_acceleration * fixed_delta
		position.z -= camera_speed * fixed_delta
	if Input.is_action_pressed("camera_backward"):
		camera_speed += camera_acceleration * fixed_delta
		position.z += camera_speed * fixed_delta
	if Input.is_action_pressed("camera_left"):
		camera_speed += camera_acceleration * fixed_delta
		position.x -= camera_speed * fixed_delta
	if Input.is_action_pressed("camera_right"):
		camera_speed += camera_acceleration * fixed_delta
		position.x += camera_speed * fixed_delta
