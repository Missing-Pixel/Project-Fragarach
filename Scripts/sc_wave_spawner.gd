class_name WaveSpawner
extends Node
## Main script for the WaveSspawner Area2D Node

signal enemy_spawned(enemy)
signal spawner_started(spawner_pos)

@export_group("Spawn Settings")
@export var spawn_interval: float = 10
@export var horizontal_distance: float = 120
@export var vertical_radius_max: float = 20
@export_group("Enemy List")
@export var enemy_folder_path: String = "res://Prefabs/Enemies/"
@export var enemy_prefab_names: PackedStringArray
@export var enemy_counts: PackedInt32Array

var enemy_prefabs: Array
var is_active: bool = false
var spawn_timer: float = 0

# Returns total enemy count
func get_enemy_count():
	var total: int = 0
	for i in enemy_counts:
		total += i
	return total

# Disable collision, set is_active to true and emit signal that spawner started
func _on_body_entered(body):
	get_child(0).disabled = true
	is_active = true
	spawner_started.emit(self.x)

# Choose random side and random vertical value. Spawn random enemy on that location
# Emits that enemy spawned
func _spawn_enemy():
	var side: int = randi_range(0, 1) # -1 = left side, 1 = right side
	if side == 0:
		side = -1
	var vertical_pos: float = randf_range(-vertical_radius_max, vertical_radius_max)
	var enemy_index: int
	var spawn_pos: Vector2 = Vector2(0, 0)
	
	# Find random position
	spawn_pos.x = self.global_position.x + horizontal_distance * side
	spawn_pos.y = self.global_position.y + vertical_pos
	
	# Find random enemy where its count is above 0
	var is_found = false
	while (is_found == false):
		enemy_index = randi_range(0, enemy_prefabs.size()-1)
		if (enemy_counts[enemy_index] > 0):
			is_found = true
			break
	
	# Spawn enemy, move it to that position and make it child of EnemyList
	var new_enemy = enemy_prefabs[enemy_index].instantiate()
	if (get_parent() != null):
		get_parent().add_child(new_enemy)
	else:
		add_child(new_enemy)
	new_enemy.global_position = spawn_pos
	enemy_spawned.emit(new_enemy)
	
	# Decrement enemy count and check if count array is all zeroes 
	enemy_counts[enemy_index] -= 1
	_check_empty()

# Check if whole list is zeroes. If true, delete self
func _check_empty():
	var is_empty = true
	
	if (enemy_counts.size() <= 0):
		self.queue_free()
		return 1
	
	for i in enemy_counts:
		if (i > 0):
			is_empty = false
			break
	
	if (is_empty == true):
		self.queue_free()
		return 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var path_string: String
	
	# Load node prefabs into enemy_prefabs array
	for i in enemy_prefab_names:
		path_string = enemy_folder_path + i
		enemy_prefabs.append(load(path_string))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_active == true) and (spawn_timer < spawn_interval):
		spawn_timer == delta
	if (spawn_timer >= spawn_interval):
		spawn_timer = 0
		_spawn_enemy()
