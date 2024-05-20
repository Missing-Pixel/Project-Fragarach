class_name SceneProcess
extends Node
## Base SceneProcess script
## Only ONE should be active at all times

@export var process_nodes: Array
@export var active_node: Node = null

# Disables current active node and enables new node inside list
func switch_nodes(new_node):
	if (process_nodes.find(new_node) != -1):
		if (active_node != null):
			active_node.set_visible(false)
			active_node.set_process(false)
		active_node = new_node
		active_node.set_visible(true)
		active_node.set_process(true)
	elif (new_node == null):
		if (active_node != null):
			active_node.set_visible(false)
			active_node.set_process(false)
		active_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide process nodes and disable them
	if (process_nodes.size() > 0):
		for n in process_nodes:
			n.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			n.set_visible(false)
			n.set_process(false)
		
		switch_nodes(process_nodes[0])