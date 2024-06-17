extends Control

@onready var hud : Control = $HUD
@onready var menu : Control = $Menu
@onready var CurrentLevel = $CurrentLevel
var level_instance : Node3D
var player_instance : CharacterBody3D
var camera_instance : CharacterBody3D
var main_menu_instance: Control

signal level_loaded

func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null

func load_level(level_name: String):
	unload_level()
	var level_path := "res://scenes/maps/%s.tscn" % level_name
	var level_resource := load(level_path)
	var player_resource := load("res://scenes/player/Player.tscn")
	var camera_resource := load("res://scenes/main/camera.tscn")
	if level_resource:
		level_instance = level_resource.instantiate()
		CurrentLevel.add_child(level_instance)
		player_instance = player_resource.instantiate()
		camera_instance = camera_resource.instantiate()
		emit_signal("level_loaded")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()

func load_main_menu():
	var menu_scene_path:= "res://scenes/menus/main_menu.tscn"
	var menu_resource:= load(menu_scene_path)
	
	if menu_resource:
		main_menu_instance = menu_resource.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
