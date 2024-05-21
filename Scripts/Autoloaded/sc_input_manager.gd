class_name InputManager
extends Node
## Sends signals out based on user input
## Signal recipients will connect to InputManager through code running in _ready() 

enum GameState { MENU=0, LEVEL=1 }

# Input signals for game state: MENU
signal inputted_move_cursor(x, y)
signal inputted_confirm_menu()
signal inputted_cancel_menu()

# Input signals for game state: LEVEL
signal inputted_move_player(x, y)
signal inputted_select_card(card_slot)
signal inputted_start_combo()
signal inputted_pause_game()

@export var game_state: GameState = GameState.LEVEL
@export var menu_move_cooldown: float = 0.2

var is_moving: bool = false
var move_timer: float = 0

# Switch game states
func switch_game_states(new_state):
	game_state = new_state

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

# Emit signals for level controls
func _emit_level_controls():
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
	if Input.is_action_just_pressed("Pause Game"):
		inputted_pause_game.emit()

# Reduces the movement axes to 4 cardinal directions, and emit if cooldown allows it
func _emit_menu_move_cursor():
	var cursor_vel: Vector2 = Vector2(0, 0)
	var vel_angle: float
	
	cursor_vel.x = Input.get_axis("Move Left", "Move Right")
	cursor_vel.y = Input.get_axis("Move Up", "Move Down")
	
	if not(cursor_vel.x == 0 and cursor_vel.y == 0) and (move_timer >= menu_move_cooldown):
		move_timer = 0
		vel_angle = _get_simple_angle_degrees(cursor_vel)
		
		# Checks angle of vector, and emits signal based on angle
		if (vel_angle <= 45) and (vel_angle > -45): 	# Right
			inputted_move_cursor.emit(1, 0)
		elif (vel_angle <= 135) and (vel_angle > 45): 	# Down
			inputted_move_cursor.emit(0, 1)
		elif (vel_angle <= -45) and (vel_angle > -135): # Up
			inputted_move_cursor.emit(0, -1)
		else: 											# Left
			inputted_move_cursor.emit(-1, 0)

# Emits menu controls
func _emit_menu_controls():
	if Input.is_action_just_pressed("Confirm Menu"):
		inputted_confirm_menu.emit()
	if Input.is_action_just_pressed("Cancel Menu"):
		inputted_cancel_menu.emit()

# Returns angle in degrees between 0 (inclusive) and 360 (exclusive)
func _get_simple_angle_degrees(input_vel: Vector2):
	var angle_rad = input_vel.angle()
	var angle_deg = angle_rad * 180/PI
	angle_deg = fmod(angle_deg, 360)
	return angle_deg

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (game_state == GameState.LEVEL):
		_emit_level_move_player()
		_emit_level_controls()
	elif (game_state == GameState.MENU):
		_emit_menu_move_cursor()
		_emit_menu_controls()
	
	if (move_timer < menu_move_cooldown):
		move_timer += delta
