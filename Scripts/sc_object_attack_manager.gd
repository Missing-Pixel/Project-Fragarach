class_name ObjectAttackManager
extends Node
## Manages the queuing of attacks, and executing their animations
## Recieves hitbox data from a signal and sends it to the target

var attack_queue: Array = []

# Add attack ID to queue. If applicable, change parent character state to ATTACKING and start anim
func add_attack(attack_id):
	if (get_parent().view_state() < 2 and attack_queue.is_empty()):
		attack_queue.append(attack_id)
		get_parent().change_state(2)
		## start animation for attack
	else:
		attack_queue.append(attack_id)

## Signal: When animation finished, either play next attack or change to idle if no more attacks

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
