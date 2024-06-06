extends DirectionalLight3D

@export var time_in_seconds: float = 21600.0
var time_in_minutes: float = 0
var time_in_hours: float = 0
var days: int

signal day_passed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Add time to variable in seconds
	time_in_seconds += delta
	
	#Calculate minutes and hours from seconds directly
	time_in_minutes = time_in_seconds / 60
	time_in_hours = time_in_minutes / 60
	if time_in_seconds >= 86400:
		emit_signal("day_passed")
		days += 1
		time_in_seconds = 0
	
	#Update lights rotation based on time
	rotation_degrees.x = ((time_in_seconds / 86400.0) * 360.0) - 90
	
	
