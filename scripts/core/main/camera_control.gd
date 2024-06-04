extends Node3D

@export var mouse_sens: float
@export var camera_acceleration: float
@export var max_camera_speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var forward = self.transform.basis.z * camera_acceleration
	
	if Input.is_action_pressed("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			var speed = Input.get_last_mouse_velocity() * (mouse_sens / 100000)
			self.rotation.y = self.rotation.y + speed.x
	
	if Input.is_action_just_released("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
