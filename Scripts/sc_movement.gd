class_name Movement
extends Node
## General Movement script

@export var max_speed : float = 7
@export_range(0, 1) var y_speed_reduce_multiplier: float = 0.7

var final_vel: Array = [0, 0]
var velocity: Array = [0, 0]
@onready var base_node: Node = get_parent()
@onready var curr_speed : float = max_speed

# Update velocity based on input
func update_velocity(vel_x, vel_y):
	velocity[0] = vel_x
	velocity[1] = vel_y

# Set final_vel based on velocity, curr speed, y_speed_reduce_multiplier
func _move_character():
	final_vel[0] = velocity[0] * curr_speed
	final_vel[1] = velocity[1] * curr_speed * y_speed_reduce_multiplier
	base_node.set_velocity(final_vel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_move_character()
	base_node.move_and_slide()
