class_name MenuControls
extends Node
## Generic controls for a menu

@export var default_button: Node
@export var movement_cooldown: float = 0.25
@export_group("Button visuals")
@export var cancel_default_color: Color
@export var active_color: Color

var current_button: Node = null
var current_coords: Array = [0, 0]
var movement_timer: float = 0
var menu_array: Array = []

# If canvas is visible and movement isn't in cooldown, move cursor
func _on_inputted_move_cursor(x_diff, y_diff):
	if (self.visible == true) and (movement_timer >= movement_cooldown):
		movement_timer = 0
		_change_button(current_coords[0] + x_diff, current_coords[1] + y_diff)

# If canvas is visible, confirm current menu option
func _on_inputted_confirm_menu():
	if (self.visible == true) and (current_button != null):
		current_button.pressed.emit()

# If canvas is visible, cancel menu with default button
func _on_inputted_cancel_menu():
	if (self.visible == true) and (default_button != null):
		default_button.pressed.emit()

# Change current button to new button depending on coordinates
# Update colors alongside the button updates
func _change_button(x, y):
	# Change current button colour before switching
	if (current_button != null):
		if (current_button == default_button):
			current_button.set_self_modulate(cancel_default_color)
		else:
			current_button.set_self_modulate(Color("WHITE"))
	
	if (y >= 0) and (y < menu_array.size()):
		if (x >= 0) and (x < menu_array[y].size()):
			current_button = menu_array[y][x]
			current_coords = [x, y]
		elif (x >= 0):
			current_button = menu_array[y][menu_array[y].size()-1]
			current_coords = [x, menu_array[y].size()-1]
	
	# Set color of current active button
	current_button.set_self_modulate(active_color)

# On ready, create 2D array of menu buttons for player to navigate around 
func _prepare_array():
	var curr_row: Array = []
	
	menu_array.clear()
	for row in get_children():
		if row is HBoxContainer:
			for cell in row.get_children():
				if cell is Button:
					curr_row.append(cell)
			menu_array.append(curr_row)
			curr_row = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input_Manager.inputted_move_cursor.connect(_on_inputted_move_cursor)
	Input_Manager.inputted_confirm_menu.connect(_on_inputted_confirm_menu)
	Input_Manager.inputted_cancel_menu.connect(_on_inputted_cancel_menu)
	
	_prepare_array()
	_change_button(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (movement_timer < movement_cooldown):
		movement_timer += delta
