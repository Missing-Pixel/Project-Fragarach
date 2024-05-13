class_name Movement
extends Node
## General Movement script

@export var autoflip_sprite: bool = true
@export var max_speed : float = 7
@export_range(0, 1) var y_speed_reduce_multiplier: float = 0.7

@export_group("Knockback")
@export var knockback_time: float = 0.1 # Should be as long as hitstun animation
@export var knockback_max_speed: float = 1
@export var knockdown_airtime: float = 0.9 # Should be longer than knockdown anim's pause point
@export var knockdown_max_speed: float = 3
@export var knockdown_distance_multiplier: float = 3

var final_vel: Vector2
var direction: Array = [0, 0]
var is_knocked_back: bool = false
var is_knocked_down: bool = false
var anim_manager: Node
var knockdown_timer: Node
@onready var curr_speed: float = max_speed

# Update direction based on input when knockback is not happening
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

# Sets knockback boolean to false and reset direction
func reset_kb():
	direction = [0, 0]
	is_knocked_back = false

# Start knockback timer, setting up the booleans, speed and direction
func start_knockback(kb_direction, kb_distance, is_knockdown = false):
	direction[0] = kb_direction.x
	direction[1] = kb_direction.y 

	is_knocked_back = true
	if (is_knockdown == true):
		var kd_distance: float = kb_distance * knockdown_distance_multiplier
		
		curr_speed = _set_knockback_speed(kd_distance, knockdown_airtime, knockdown_max_speed)
		is_knocked_down = is_knockdown
		get_parent().change_state(3)
		get_parent().node_action_manager.play_knocked_down()
		knockdown_timer.wait_time = knockdown_airtime
	else:
		curr_speed = _set_knockback_speed(kb_distance, knockback_time, knockback_max_speed)
		get_parent().node_action_manager.play_hitstun()
	
	knockdown_timer.start

# Return speed equal to distance/time. Reduce if it exceeds limit
func _set_knockback_speed(distance, time, limit):
	var speed: float = distance/time
	
	if (speed > limit):
		speed = limit
	return speed

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
			knockdown_timer = c
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_move_character()
	get_parent().move_and_slide()
	
	if (autoflip_sprite):
		_autoflip_sprite()

# Disable knockback, resets velocity and resumes KD animation
func _on_timer_timeout():
	direction = [0, 0]
	is_knocked_down = false
	get_parent().node_action_manager.resume_animation()
