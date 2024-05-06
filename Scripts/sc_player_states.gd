class_name PlayerStates
extends CharacterStates
## Variant of CharacterStates, meant for managing inputs for the Player

signal moved_player(velocity)
signal selected_card(card_slot_value)

var input_velocity: Array = [0, 0]

# Relay move player signal to movement script
# Input applicable in IDLE and MOVING states
func _on_input_move(x, y):
	if (current_state == States.IDLE or current_state == States.MOVING):
		input_velocity = [x, y]
		moved_player.emit(input_velocity)

# Relay select card signal to card management script
# Input applicable in IDLE and MOVING states
func _on_input_select_card(card_slot):
	if (current_state == States.IDLE or current_state == States.MOVING):
		# Relay info into new signal
		selected_card.emit(card_slot)

# Check if array has only zeroes
func _check_all_zero(array):
	for i in array:
			if (i != 0):
				return false
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	var input_manager = $"../GlobalVariables/InputManager"
	input_manager.inputted_move_player.connect(_on_input_move)
	input_manager.inputted_select_card.connect(_on_input_select_card)
	
	current_state = States.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Switches between IDLE and MOVING states depending on whether player is moving
	if (current_state == States.IDLE and not _check_all_zero(input_velocity)):
		current_state = States.MOVING
	elif (current_state == States.MOVING and _check_all_zero(input_velocity)):
		current_state = States.IDLE
	pass
