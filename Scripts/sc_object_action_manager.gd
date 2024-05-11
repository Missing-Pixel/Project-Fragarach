class_name ObjectActionManager
extends Node
## General manager script for object's actions and animations
## Recieves hitbox data from a signal and sends it to the target

@export_group("Animation Names")
@export var anim_library: String
@export var anim_idle: String
@export var anim_move: String
# index = ID of attack (int)
# value = attack animation name (string) 
@export var anim_attacks: PackedStringArray

var anim_player: Node
var attack_queue: Array = []

# Plays idle animation
func play_idle():
	var anim_path = anim_library + anim_idle
	anim_player.play(anim_path)

# Plays moving animation
func play_moving():
	var anim_path = anim_library + anim_move
	anim_player.play(anim_path)

# Plays an attacking animation
func play_attack(attack_index: int):
	var anim_path = anim_library + anim_attacks[attack_index]
	anim_player.play(anim_path)

# Add attack ID to queue. If applicable, change parent character state to ATTACKING and start anim
func add_attack(attack_id):
	if (get_parent().view_state() < 2 and attack_queue.is_empty()):
		attack_queue.append(attack_id)
		get_parent().change_state(2)
		get_parent().node_attack_animator.play_attack(attack_id)
	else:
		attack_queue.append(attack_id)

## On Signal: When animation finished, play next attack and remove 1 card
## change to idle if no more attacks

## On Signal: When hitbox connects, relay damage values to recipient

# Called when the node enters the scene tree for the first time.
func _ready(): 
	for c in get_children():
		if (c is AnimationPlayer):
			anim_player = c
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
