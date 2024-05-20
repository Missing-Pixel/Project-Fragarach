class_name LevelProcess
extends SceneProcess
## Uses SceneProcess to manage level menu management
## Only ONE should be active at all times

signal level_won(lvl_id)

@export var level_id: int = 0
@export var pause_menu: Node
@export var game_over: Node

# Pause game and open pause menu
func _on_inputted_pause_game():
	_toggle_pause(true)

# Show game over loss screen when player dies
func _on_player_died(player_node):
	pass # Show game over loss

# Show game win screen when level clears
func _on_level_clear():
	pass # Show game over win

## Show game over with appropriate text based on win or loss
# Pause
# Show Game Over (win/loss)
# loss: show loss text
# win: show win text and emit flag to save data

# Toggle pause and change input manager states
func _toggle_pause(will_pause: bool):
	if (will_pause == true):
		get_tree().paused = true
		Input_Manager.switch_game_states(0)
	else:
		get_tree().paused = false
		Input_Manager.switch_game_states(1)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect Pause menu signal
	Input_Manager.inputted_pause_game.connect(_on_inputted_pause_game)
	
	# Sets process mode of itself to always and sets its children to pausable 
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# Set process nodes' process modes to whenpaused, hide them and disable them
	if (process_nodes.size() > 0):
		for n in process_nodes:
			n.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			n.set_visible(false)
			n.set_process(false)
	
	# Find Player and EnemyList to connect appropriate values
	if ($Player != null):
		$Player.character_died.connect(_on_player_died)
	if ($EnemyList != null):
		$EnemyList.level_cleared_connect(_on_level_clear)
	
	_toggle_pause(false)
	switch_nodes(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
