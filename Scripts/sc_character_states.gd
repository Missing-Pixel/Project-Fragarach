class_name CharacterStates
extends Node
## Base character state manager

signal character_died(node_ref)

enum States {IDLE=0, MOVING=1, ATTACKING=2, KNOCKED_DOWN=3}
@export var current_state: States = States.IDLE

var input_velocity: Array = [0, 0]
var nodes_sprites: Array

var node_action_manager: Node
var node_move_manager: Node
var node_health_manager: Node

# Change state through a function rather than a public variable
func change_state(new_state):
	current_state = new_state

# View current state of character
func view_state():
	var state_id: int = current_state
	return state_id

# Link node variable to appropriate child node depending on example method string
func _child_node_link(example_method):
	for child in get_children():
		if child.has_method(example_method):
			return child

# Check if array has only zeroes
func _check_all_zero(array):
	for i in array:
			if (i != 0):
				return false
	return true

# Recursively look through all children  and appends list of nodes that are Sprite2D
func _list_sprite_nodes(curr_node = self):
	for c in curr_node.get_children():
		if (c is Sprite2D):
			nodes_sprites.append(c)
		if (c.get_child_count() > 0):
			_list_sprite_nodes(c)

# Update all sprite nodes' z-index
func _update_z_index():
	for s in nodes_sprites:
		s.z_index = self.global_position.y * 0.1

# Base _ready method
func _ready():
	# Link node components
	node_action_manager = _child_node_link("add_attack")
	node_move_manager = _child_node_link("update_velocity")
	node_health_manager = _child_node_link("get_damaged")
	_list_sprite_nodes()
	
	current_state = States.IDLE

# Base _process method
func _process(_delta):
	# While moving: Update all sprite's z-index
	if (current_state == States.MOVING):
		_update_z_index()
	
	# Switches between IDLE and MOVING states depending on whether player moves
	if (current_state == States.IDLE and not _check_all_zero(input_velocity)):
		current_state = States.MOVING
	elif (current_state == States.MOVING and _check_all_zero(input_velocity)):
		current_state = States.IDLE
