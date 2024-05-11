class_name Movement
extends Node
## General Movement script

@export var autoflip_sprite: bool = true
@export var max_speed : float = 7
@export_range(0, 1) var y_speed_reduce_multiplier: float = 0.7

@export_group("Knockback")
@export var knockback_time: float = 0.02
@export var knockback_speed: float = 1
@export var knockdown_airtime: float = 0.6
@export var knockdown_speed: float = 3

var final_vel: Vector2
var direction: Array = [0, 0]
var is_knocked_back: bool = false
var is_knocked_down: bool = false
var anim_manager: Node
var kb_timer: Node
@onready var curr_speed: float = max_speed

# Update direction based on input
func update_velocity(vel_x, vel_y, speed = max_speed):
	if (is_knocked_back == false):
		direction[0] = vel_x
		direction[1] = vel_y
		curr_speed = max_speed

# Returns the maximum movement speed of the character
func get_max_speed():
	return max_speed

# Returns boolean of whether character is being knocked back
func get_is_knocked_back():
	return is_knocked_back

# Returns knockdown airtime
func get_knockdown_airtime():
	return knockdown_airtime

# Sets knockback boolean to false
func set_kb_false():
	is_knocked_back = false

# Start knockback timer, setting up the booleans, speed and direction
func start_knockback(kb_direction, kb_distance, is_knockdown = false):
	direction = kb_direction

	is_knocked_back = true
	if (is_knockdown == true):
		curr_speed = kb_distance/knockdown_airtime
		is_knocked_down = is_knockdown
		get_parent().change_state(3)
		get_parent().node_action_manager.play_knocked_down()
		kb_timer.wait_time = knockdown_airtime
	else:
		curr_speed = kb_distance/knockback_time
		kb_timer.wait_time = knockback_time
	
	kb_timer.start


# Flip sprite based on vel_x value's sign
func _autoflip_sprite():
	if (direction[0] > 0):
		get_parent().node_action_manager.scale.x = 1
	elif (direction[0] < 0):
		get_parent().node_action_manager.scale.x = -1

# Set final_vel based on direction, curr speed, y_speed_reduce_multiplier
func _move_character():
	final_vel.x = direction[0] * curr_speed
	final_vel.y = direction[1] * curr_speed * y_speed_reduce_multiplier
	get_parent().set_velocity(final_vel)

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_manager = get_parent().node_action_manager
	for c in get_children():
		if (c is Timer):
			kb_timer = c
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_move_character()
	get_parent().move_and_slide()
	
	if (autoflip_sprite):
		_autoflip_sprite()

# Disable knockback if knockback was the only condition. Disables knockdown otherwise
# When knockdown disabled, knockback is disabled later when KNOCKED_DOWN state ends
func _on_timer_timeout():
	direction = [0, 0]
	if (is_knocked_down == true):
		is_knocked_down = false
		get_parent().node_action_manager.resume_animation()
	else:
		is_knocked_back = false
