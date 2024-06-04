extends Node3D

@export var mouse_sens: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_pressed("camera_rotate"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.rotation.x = self.rotation.x + InputEventMouseMotion.relative.x
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
