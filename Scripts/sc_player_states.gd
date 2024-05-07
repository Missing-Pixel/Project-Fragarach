class_name PlayerStates
extends CharacterStates
## Variant of CharacterStates, meant for managing inputs for the Player

# The following signals would need to be manually connected to noted scripts
signal moved_player(velocity) # Movement

var input_velocity: Array = [0, 0]

var node_card_manager: Node
var node_attack_manager: Node

# Relay move player signal to movement script
func _on_input_move(x, y):
	input_velocity = [x, y]
	if (current_state == States.IDLE or current_state == States.MOVING):
		moved_player.emit(input_velocity)

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
	var input_manager = $"../GlobalVariables/InputManager"
	input_manager.inputted_move_player.connect(_on_input_move)
	input_manager.inputted_select_card.connect(_on_input_select_card)
	input_manager.inputted_start_combo.connect(_on_input_start_combo)
	_child_node_link(node_card_manager, "_create_deck")
	_child_node_link(node_attack_manager, "add_attack")
	
	
	current_state = States.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Switches between IDLE and MOVING states depending on whether player moves
	if (current_state == States.IDLE and not _check_all_zero(input_velocity)):
		current_state = States.MOVING
	elif (current_state == States.MOVING and _check_all_zero(input_velocity)):
		current_state = States.IDLE
	pass
