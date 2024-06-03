class_name MenuProcess
extends SceneProcess
## Workaround script to get all children of canvas layer onto the process_nodes

@export var canvas_node: Node
@export_group("Menus")
@export var title_page: Node
@export var credits_page: Node

# Plays level
func _on_play_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/test_level.tscn")
	Audio_Manager.play_sound("SFX_Menu")

# Switch to Credits screen
func _on_credits_menu_pressed():
	switch_nodes(title_page)
	Audio_Manager.play_sound("SFX_Menu")

# Switch to Title screen
func _on_title_menu_presssed():
	switch_nodes(credits_page)
	Audio_Manager.play_sound("SFX_Menu")

# Exit game
func _on_exit_game_pressed():
	get_tree().quit()
	Audio_Manager.play_sound("SFX_Menu")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start menu unpaused and with menu input state
	get_tree().paused = false
	Input_Manager.switch_game_states(0)
	
	# Add every child from canvas node to process_nodes before continuing 
	for child in canvas_node.get_children():
		if (process_nodes.find(child) == -1):
			process_nodes.append(child)
	
	# Hide process nodes and disable them
	if (process_nodes.size() > 0):
		for n in process_nodes:
			n.set_visible(false)
			n.set_process(false)
		
		switch_nodes(process_nodes[0])
