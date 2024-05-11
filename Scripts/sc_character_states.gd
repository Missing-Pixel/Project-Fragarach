class_name CharacterStates
extends Node
## Base character state manager

enum States {IDLE=0, MOVING=1, ATTACKING=2, KNOCKED_DOWN=3}
@export var current_state: States = States.IDLE

var input_velocity: Array = [0, 0]
var nodes_sprites: Array

# Change state through a function rather than a public variable
func change_state(new_state):
	current_state = new_state

# View current state of character
func view_state():
	var state_id: int = current_state
	return state_id

# Link node variable to appropriate child node depending on example method string
func _child_node_link(_var_node, example_method):
	for child in get_children():
		if child.has_method(example_method):
			_var_node = child

# Check if array has only zeroes
func _check_all_zero(array):
	for i in array:
			if (i != 0):
				return false
	return true

# Recursively look through all children  and appends list of nodes that are Sprite2D
func _list_sprite_nodes():
	for c in get_children():
		if (c is Sprite2D):
			nodes_sprites.append(c)
		if (c.get_child_count() > 0):
			_list_sprite_nodes()

# Update all sprite nodes' z-index
func _update_z_index():
	for s in nodes_sprites:
		s.z_index = self.global_position.y * 0.1

# Base _process method
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# While moving: Emit signal of player position and update all sprite's z-index
	if (current_state == States.MOVING):
		_update_z_index()
	
	# Switches between IDLE and MOVING states depending on whether player moves
	if (current_state == States.IDLE and not _check_all_zero(input_velocity)):
		current_state = States.MOVING
	elif (current_state == States.MOVING and _check_all_zero(input_velocity)):
		current_state = States.IDLE
