extends Movement
## Movement script for the player

# Update velocity based on input
func update_player_vel(vel_x, vel_y):
	velocity[0] = vel_x
	velocity[1] = vel_y
