class_name InputManager
extends Node
## Sends signals out based on user input
## Signal recipients will connect to InputManager through code running in _ready() 

enum GameState { MENU=0, LEVEL=1, DEBUG=99}

# Input signals for game state: LEVEL
signal inputted_move_player(x, y)
signal inputted_select_card(card_slot)
signal inputted_start_combo()

@export var game_state: GameState = GameState.LEVEL
@export_group("DEBUG")
@export var check_move: bool = false
@export var check_buttons: bool = false

var is_moving: bool = false

# Emit signal for controlling player movement
func _emit_level_move_player():
	var vel_x = Input.get_axis("Move Left", "Move Right")
	var vel_y = Input.get_axis("Move Up", "Move Down")
	
	if not(vel_x == 0 and vel_y == 0):
		inputted_move_player.emit(vel_x, vel_y)
		is_moving = true
	elif (is_moving == true):
		# When letting go of inputs from moving, emit one (0,0) signal
		inputted_move_player.emit(0, 0)
		is_moving = false

# Emit signals for card management controls
func _emit_level_card_management():
	if Input.is_action_just_pressed("Select Card 1"):
		inputted_select_card.emit(1)
	if Input.is_action_just_pressed("Select Card 2"):
		inputted_select_card.emit(2)
	if Input.is_action_just_pressed("Select Card 3"):
		inputted_select_card.emit(3)
	if Input.is_action_just_pressed("Select Card 4"):
		inputted_select_card.emit(4)
	
	if Input.is_action_just_pressed("Start Combo"):
		inputted_start_combo.emit()
	pass

# Switch game states
func switch_game_states(new_state):
	game_state = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (game_state == GameState.LEVEL or game_state == GameState.DEBUG):
		_emit_level_move_player()
		_emit_level_card_management()
	
	# -------------------------------------------------------------------------
	# DEBUG
	_debug_check_bind()

# -------------------------------------------------------------------------------------------------
# DEBUG SECTION 
signal started_debug()
# Called when the node enters the scene tree for the first time.
func _ready():
	if (game_state == GameState.DEBUG):
		started_debug.emit()
# Debug: print pressed bind
func _debug_check_bind():
	if Input.is_action_just_pressed("Select Card 1"):
		print("Select Card 1", " pressed")
	if Input.is_action_just_pressed("Select Card 2"):
		print("Select Card 2", " pressed")
	if Input.is_action_just_pressed("Select Card 3"):
		print("Select Card 3", " pressed")
	if Input.is_action_just_pressed("Select Card 4"):
		print("Select Card 4", " pressed")
	if Input.is_action_just_pressed("Start Combo"):
		print("Start Combo", " pressed")
