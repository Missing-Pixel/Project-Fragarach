class_name EnemyList
extends Node2D
## Main script to manage enemies. 
## All enemies and wave spawners should be children of List

signal enemy_flag_triggered(left_limit, right_limit, is_locked)

@export var enemy_flag_resource: Resource
@export_group("Speedlag")
@export_range(0, 1) var move_speed_reduce_multiplier: float = 0.5
@export_range(0, 1) var attack_rate_reduce_multiplier: float = 0.5

var enemy_max: int = 0
var enemy_death_count: int = 0
var tagged_enemy: Node = null
var loaded_enemies: Array = []

# Add enemy to loaded_enemies and connect its values
func _on_enemy_spawned(enemy):
	loaded_enemies.append(enemy)
	# Connect on_character_died, on_player_found, on_player_left

# Set enemy speed based on whether enemy is tagged or not
func _on_player_found(enemy):
	if (tagged_enemy == null):
		tagged_enemy = enemy
		enemy.set_speedlag_tag(true)
	elif (tagged_enemy != null) and (tagged_enemy != enemy):
		enemy.set_speedlag_tag(false, attack_rate_reduce_multiplier, move_speed_reduce_multiplier)

# Reset speedlag tag if player left search radius
func _on_player_left(enemy):
	if (tagged_enemy == enemy):
		pass
		_reset_speedlag_tag()

# Increae death count, remove enemy form loaded_enemies and destroy enemy
# If enemy is tagged, reset speedlag tag 
# If there are no more enemies, start the end_level sequence. Else, check the flags
func _on_character_died(enemy):
	var enemy_index: int = loaded_enemies.find(enemy)
	
	enemy_death_count += 1
	loaded_enemies.remove_at(enemy_index)
	if (tagged_enemy == enemy):
		_reset_speedlag_tag()
	enemy.queue_free()
	
	if (enemy_death_count == enemy_max):
		pass ## Start the end level sequence
	else:
		_check_flags()

# Check if current enemy death count is in the resource.
# If so, emit enemy_flag_triggered
func _check_flags():
	var search_index: int = enemy_flag_resource.deaths.find(enemy_death_count)
	
	if (search_index != -1):
		enemy_flag_triggered.emit(
			enemy_flag_resource.left_limits[search_index], 
			enemy_flag_resource.right_limits[search_index], 
			enemy_flag_resource.locked_flags[search_index])

# Sets tagged_enemy to null, then finds priority enemy to tag next
func _reset_speedlag_tag():
	var closest_enemy: Node
	var close_health: float = -1
	var close_distance: float = 99999
	var curr_details: Array
	var previous_enemy = tagged_enemy
	
	if (tagged_enemy != null):
		tagged_enemy.set_speedlag_tag(false, attack_rate_reduce_multiplier, move_speed_reduce_multiplier)
		tagged_enemy = null
	
	if (loaded_enemies.size() > 0):
		closest_enemy = loaded_enemies[0]
		
		# Prioritises if player found, then highest max health, then closest to player
		# Skips to next enemy if it is same as the previously tagged one
		for enemy in loaded_enemies:
			curr_details = enemy.get_enemy_details()
			if (enemy != previous_enemy):
				if (curr_details[0] > close_health):
					closest_enemy = enemy
					close_health = curr_details[0]
					close_distance = curr_details[1]
				elif (curr_details[0] == close_health):
					if (curr_details[1] <= close_distance):
						closest_enemy = enemy
						close_distance = curr_details[1]
		
		tagged_enemy = closest_enemy
		closest_enemy.set_speedlag_tag(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CharacterBody2D: # +1 enemy_max, add child to loaded_enemies and connect signals
			enemy_max += 1
			_on_enemy_spawned(child)
		elif child is Area2D:
			# enemy_max = child.get_enemy_count()
			# Connect on_enemy_spawned(enemy)
			# Connect _on_spawner_started(spawner_pos)
			pass

