extends Node3D

@onready var player: Node3D = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_main_scene_level_loaded():
	var player_position: Vector3 = get_node("PlayerSpawn").transform
	player.position = player_position