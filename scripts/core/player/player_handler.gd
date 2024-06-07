extends Node3D

@onready var player : Node3D = self
@onready var navigation_agent := $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("interact"):
		var target_position = raycast()
		move_player(target_position)

func raycast():
	var camera: Camera3D = get_node("Camera").find_child("Camera3D")
	if camera == null:
		printerr("Error! Can't find Camera3D!")
	var interact_pos = get_viewport().get_interact_position()
	var ray_length = 100
	var from = camera.project_ray_origin(interact_pos)
	var to = from + camera.project_ray_normal(interact_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	
	var result = space.intersect_ray(ray_query)
	
	return result

func move_player(target_position):
	pass

func _on_level_loaded():
	var player_spawn: Vector3 = get_node("PlayerSpawn").transform
	player.position = player_spawn
