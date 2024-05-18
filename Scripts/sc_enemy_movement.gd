class_name EnemyMovement
extends Movement
## Enemy specific movement script to manage speedlag

@onready var speedlag_speed: float = max_speed

# Set enemy speed based on whether it is tagged or not
func set_enemy_speed(is_tagged, reduce_multi = 1):
	if (is_tagged == true):
		speedlag_speed = max_speed
	else:
		speedlag_speed = max_speed * reduce_multi

# Update direction based on input when knockback is not happening
func update_velocity(vel_x, vel_y, speed = max_speed):
	if (is_knocked_back == false):
		direction[0] = vel_x
		direction[1] = vel_y
		curr_speed = speedlag_speed
