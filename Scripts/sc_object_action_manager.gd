class_name ObjectActionManager
extends Node
## General manager script for object's actions and animations
## Need to manually connect the following signals:
## AnimationPlayer - animation_finished
## Hitbox - body_entered

@export var attack_range: Node
@export_group("Animation Names")
@export var anim_library: String
@export var anim_idle: String
@export var anim_move: String
@export var anim_knockdown: String
# index = ID of attack (int)
# value = attack animation name (string) 
@export var anim_attacks: PackedStringArray

var anim_player: Node
var hitbox_manager: Node
var health_manager: Node
var attack_queue: Array = []

# Plays idle animation
func play_idle():
	_play_animation(anim_idle)

# Plays moving animation
func play_moving():
	_play_animation(anim_move)

# Plays an attacking animation
func play_next_attack():
	_play_animation(anim_attacks[0])

# Add attack ID to queue. If applicable, change parent character state to ATTACKING and start anim
func add_attack(attack_id):
	if (get_parent().view_state() < 2 and attack_queue.is_empty()):
		attack_queue.append(attack_id)
		get_parent().change_state(2)
		play_next_attack()
	else:
		attack_queue.append(attack_id)

# General play animation function
func _play_animation(anim_file_name):
	var anim_path = anim_library + "/" + anim_file_name
	anim_player.play(anim_path)

# When animation finished, play next attack and remove 1 card
# Change to idle if no more attacks are in queue
func _on_animation_player_animation_finished(anim_name):
	attack_queue.remove_at(0)
	get_parent().node_card_manager.discard_front_card()
	
	if (attack_queue.size() > 0):
		play_next_attack()
	else:
		get_parent().change_state(0)
		play_idle()

# When hitbox connects, and target's base collision is in attack range,
# relay information to target's health manager
func _on_hitbox_body_entered(body):
	if (body != self):
		if (attack_range.get_overlapping_bodies().has(body.get_parent())):
			# Find direction to target from self
			var vel_direction: Vector2
			vel_direction = body.get_parent().global_position - get_parent().global_position
			
			# Relay info to target
			body.health_manager.get_damaged(
				hitbox_manager.base_damage, hitbox_manager.damage_type, 
				hitbox_manager.base_kb_distance, vel_direction, hitbox_manager.is_knockdown)


# Called when the node enters the scene tree for the first time.
func _ready(): 
	health_manager = get_parent().node_health_manager
	for c in get_children():
		if (c is AnimationPlayer):
			anim_player = c
		elif (c is Area2D):
			hitbox_manager = c
