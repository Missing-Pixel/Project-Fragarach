class_name ObjectActionManager
extends Node
## General manager script for object's actions and animations
## Need to manually connect the following signals:
## AnimationPlayer - animation_finished
## Hitbox - target_connected

@export_group("Animation Names")
@export var anim_library: String
@export var anim_idle: String
@export var anim_move: String
@export var anim_knockdown: String
# index = ID of attack (int)
# value = attack animation name (string) 
@export var anim_attacks: PackedStringArray

var anim_player: Node
var attack_queue: Array = []

# Plays idle animation
func play_idle():
	_play_animation(anim_idle)

# Plays moving animation
func play_moving():
	_play_animation(anim_move)

# Plays an attacking animation
func play_attack(attack_index: int):
	_play_animation(anim_attacks[attack_index])

# Add attack ID to queue. If applicable, change parent character state to ATTACKING and start anim
func add_attack(attack_id):
	if (get_parent().view_state() < 2 and attack_queue.is_empty()):
		attack_queue.append(attack_id)
		get_parent().change_state(2)
		play_attack(attack_id)
	else:
		attack_queue.append(attack_id)

# General play animation function
func _play_animation(anim_file_name):
	var anim_path = anim_library + "/" + anim_file_name
	anim_player.play(anim_path)

## On Signal: When animation finished, play next attack and remove 1 card
## Change to idle if no more attacks

## On Signal: When hitbox connects, relay damage values to target

# Called when the node enters the scene tree for the first time.
func _ready(): 
	for c in get_children():
		if (c is AnimationPlayer):
			anim_player = c
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
