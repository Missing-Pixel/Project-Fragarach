class_name PlayerStates
extends CharacterStates
## Variant of CharacterStates, meant for managing inputs for the Player

signal showed_player_position(parent_pos)

var node_card_manager: Node
var node_action_manager: Node
var node_move_manager: Node
var node_health_manager: Node

# Relay move player signal to movement script
func _on_input_move(x, y):
	input_velocity = [x, y]
	if (current_state == States.IDLE or current_state == States.MOVING):
		node_move_manager.update_velocity(x, y)

# Relay select card signal to card management script
func _on_input_select_card(card_slot):
	if (current_state == States.IDLE or current_state == States.MOVING):
		node_card_manager.select_card(card_slot)

# Relay initiating combo to card management script
func _on_input_start_combo():
	if (current_state == States.IDLE or current_state == States.MOVING):
			node_card_manager.start_combo()
			current_state = States.ATTACKING

# Called when the node enters the scene tree for the first time.
func _ready():
	# Link input signals and node components
	Input_Manager.inputted_move_player.connect(_on_input_move)
	Input_Manager.inputted_select_card.connect(_on_input_select_card)
	Input_Manager.inputted_start_combo.connect(_on_input_start_combo)
	node_card_manager = _child_node_link("select_card")
	node_action_manager = _child_node_link("add_attack")
	node_move_manager = _child_node_link("update_velocity")
	node_health_manager = _child_node_link("get_damaged")
	_list_sprite_nodes()
	
	current_state = States.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# While moving: Emit signal of player position and update all sprite's z-index
	if (current_state == States.MOVING):
		showed_player_position.emit(self.global_position)
		_update_z_index()
	
	# Switches between IDLE and MOVING states depending on whether player moves
	if (current_state == States.IDLE and not _check_all_zero(input_velocity)):
		current_state = States.MOVING
		node_action_manager.play_moving()
	elif (current_state == States.MOVING and _check_all_zero(input_velocity)):
		current_state = States.IDLE
		node_action_manager.play_idle()
