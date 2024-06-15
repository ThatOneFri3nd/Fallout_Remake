extends CharacterBody3D

@onready var player : Node3D = self
@onready var navigation_agent := $NavigationAgent3D
@export var movement_speed: float = 10
@export var ray_length: float = 10000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	move_to_point(delta, movement_speed)

func move_to_point(delta, speed):
	var target_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(target_position)
	
	velocity = direction * speed
	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("interact"):
		var interact_result = raycast()
		move_player(interact_result)

func raycast():
	var camera: Camera3D = get_node("../Camera/Camera3D")
	if camera == null:
		printerr("Error! Can't find Camera3D!")
	var interact_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(interact_pos)
	var to = from + camera.project_ray_normal(interact_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	
	var result = space.intersect_ray(ray_query)
	return result

func move_player(interact_result):
	navigation_agent.target_position = interact_result.position

func _on_level_loaded():
	var player_spawn: Vector3 = get_node("PlayerSpawn").transform
	player.position = player_spawn
