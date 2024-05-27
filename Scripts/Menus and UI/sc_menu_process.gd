class_name MenuProcess
extends SceneProcess
## Workaround script to get all children of canvas layer onto the process_nodes

@export var canvas_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
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
