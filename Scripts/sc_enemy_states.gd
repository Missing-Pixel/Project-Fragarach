class_name EnemyStates
extends CharacterStates
## Variant of CharacterStates, meant for managing Enemy detection and attacking
## Needed signals:
## Player - showed_player_position
## SearchRange - body_entered, body_exited
## AttackRange - body_entered, body_exited
## SearchTimer - timeout

signal player_found(enemy)
signal player_left(enemy)

@export_group("Movement Detection")
@export var player_search_period: float = 0.6
@export var deadzone_range: float = 1 
@export var search_timer: Node
@export_group("Attack Conditions")
@export var attack_cooldown: float = 0.5
@export var lag_cooldown_multiplier: float = 2

var player_node: Node
var player_position: Array = [0, 0]
var is_in_deadzone: bool = false
var is_search_ready: bool = true
var is_player_in_range: bool = false
var is_enemy_speedlag_tagged: bool = true
var speedlag_cooldown_multi: float = 1

@onready var delayed_player_pos: Array = player_position
@onready var attack_timer: float = attack_cooldown

# Set the attack_cooldown based on reduction multi, and send other values to movement script
func set_speedlag_tag(is_tagged, cooldown_multi = speedlag_cooldown_multi, speed_multi = 1):
	if (is_tagged == false):
		is_enemy_speedlag_tagged = false
		speedlag_cooldown_multi = cooldown_multi
		_reset_attack_timer()
	node_move_manager.set_enemy_speed(is_tagged, speed_multi)

# Returns an array of enemy's maxHP and distance to player
# Returns [0, 9999] if player isn't in range
func get_enemy_details():
	var health: float = node_health_manager.max_health
	var diff_x: float = player_position[0] - self.global_position.x
	var diff_y: float = player_position[1] - self.global_position.y
	var distance: float = sqrt(diff_x**2 + diff_y**2)
	
	if (is_player_in_range == false):
		return [0, 9999]
	else:
		return [health, distance]

# Connect to body's signal if it isn't already
func _on_search_range_body_entered(body):
	if (body.showed_player_position.is_connected(_on_player_position_shown) == false):
		body.showed_player_position.connect(_on_player_position_shown)
		player_node = body

# Disconnect from body's signal if it isn't already
func _on_search_range_body_exited(body):
	if (body.showed_player_position.is_connected(_on_player_position_shown) == true):
		body.showed_player_position.disconnect(_on_player_position_shown)
		player_node = null

# Set is_player_in_range to true
func _on_attack_range_body_entered(body):
	is_player_in_range = true
	player_found.emit(self)

# Reset attack_timer and set is_player_in_range to false
func _on_attack_range_body_exited(body):
	if (body == player_node):
		_reset_attack_timer()
		is_player_in_range = false
		player_left.emit(self)

# Update player position
func _on_player_position_shown(pos):
	player_position[0] = pos.x
	player_position[1] = pos.y

# Return the magnitude difference between two positions
func _distance_between_pos_2D(pos_one, pos_two):
	var a: float = absf(pos_one[0] - pos_two[0]) 
	var b: float = absf(pos_one[1] - pos_two[1])
	var c: float = sqrt(a**2 + b**2)
	return c

# Return the direction to pos_two from pos_one
func _direction_between_pos_2D(pos_one, pos_two):
	var direction: Vector2 = Vector2(0, 0)
	direction.x = pos_two[0] - pos_one[0]
	direction.y = pos_two[1] - pos_one[1]
	return direction.normalized()

# Periodically update delayed player postion. 
# Cooldown is enforced with search timer's timeout signal
func _update_delayed_pos():
	delayed_player_pos = player_position
	
	search_timer.wait_time = player_search_period
	search_timer.start()
	await search_timer.timeout
	is_search_ready = true

# Approach player's point
func _approach_player():
	var dir_vector: Vector2 = _direction_between_pos_2D(
		self.global_position, delayed_player_pos)
	
	if (node_move_manager.get_is_knocked_back() == false):
		input_velocity = [dir_vector.x, dir_vector.y]
		if (current_state == States.IDLE or current_state == States.MOVING):
			node_move_manager.update_velocity(dir_vector.x, dir_vector.y)

# Add random attack to attack queue
func _add_random_attack():
	var r: int = randi_range(0, node_action_manager.get_attack_count()-1)
	
	input_velocity = [0, 0]
	node_move_manager.update_velocity(0, 0)
	node_action_manager.add_attack(r)

# Charge up attack when player in range. Queue a random attack when charged. 
func _charge_attack(delta):
	attack_timer -= delta
	if (attack_timer <= 0):
		_reset_attack_timer()
		_add_random_attack()

# Reset attack_timer based on whether enemy is tagged or not
func _reset_attack_timer():
	if (is_enemy_speedlag_tagged == false):
		attack_timer = attack_cooldown * (1/speedlag_cooldown_multi)
	else:
		attack_timer = attack_cooldown

func _process(delta):
	# While moving: Update all sprite's z-index
	if (current_state == States.MOVING):
		_update_z_index()
	
	# Switches between IDLE and MOVING states depending on whether player moves
	if (current_state == States.IDLE and not _check_all_zero(input_velocity)):
		current_state = States.MOVING
	elif (current_state == States.MOVING and _check_all_zero(input_velocity)):
		current_state = States.IDLE
	
	# Check if player found and is in IDLE or MOVING state
	if (player_node != null and (current_state == States.IDLE or current_state == States.MOVING)):
		if (is_search_ready == true):
			is_search_ready == false
			_update_delayed_pos()
		
		if (is_in_deadzone == false):
			_approach_player()
		
		if (_distance_between_pos_2D(delayed_player_pos, self.global_position) < deadzone_range):
			is_in_deadzone = true
			input_velocity = [0, 0]
		else:
			is_in_deadzone = false
		
		if (is_player_in_range == true):
			_charge_attack(delta)
