class_name PlayerCamera
extends Camera2D
## Main camera script for the player camera
## Requires the following signal conencted: enemy_flag_triggered(left, right, is_locked = false)
# From camera2D, uses limit_left, limit_right, position_smoothing_speed, position_smoothing_enabled

@export var camera_collision_margin: float = 0
@export var default_camera_speed: float = 1
@export var locking_camera_speed: float = 3

var left_bounds: Node
var right_bounds: Node

# Update camera limits with new bound values. 
# If camera is getting locked, set both limits to left_bound, and increase camera speed
func _on_enemy_flag_triggered(left_bounds, right_bounds, is_locked = false):
	if (is_locked == true):
		limit_left = left_bounds
		limit_right = left_bounds
		position_smoothing_speed = locking_camera_speed
	else:
		limit_left = left_bounds
		limit_right = right_bounds
		position_smoothing_speed = default_camera_speed

#Snap camera to player whenever it is called
func _snap_camera():
	position_smoothing_enabled = false
	await Engine.get_main_loop().process_frame
	position_smoothing_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	left_bounds = $LeftBounds
	right_bounds = $RightBounds
	
	position_smoothing_speed = default_camera_speed
	_snap_camera()
	
	# Setup bound collision margins
	left_bounds.position.x += camera_collision_margin
	right_bounds.position.x -= camera_collision_margin
	
	# Connect EnemyList's signal to script
	get_node("/root/EnemyList").enemy_flag_triggered.connect(_on_enemy_flag_triggered)
