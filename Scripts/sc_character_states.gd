class_name CharacterStates
extends Node
## Base character state manager

enum States {IDLE=0, MOVING=1, ATTACKING=2, KNOCKED_DOWN=3}
@export var current_state: States = States.IDLE

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
