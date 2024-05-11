class_name PlayerActionManager
extends ObjectActionManager
## Player specific action manager script to add damage overrides 
## Need to manually connect the following signals:
## AnimationPlayer - animation_finished
## Hitbox - body_entered

@export_group("Player Combos")
@export var repeat_attack_bonus: float = 2
@export var last_attack_bonus: float = 2
@export var last_attack_ids: PackedInt32Array = []
@export var knockdown_last_attack_ids: PackedInt32Array = []

var previous_attack_id: int = 0
var combo_counter: int = 0

# Modify various damage properties based on player combos 
func _relay_info(target):
	var vel_direction: Vector2
	var final_damage: float = hitbox_manager.base_damage
	var is_knockdown: bool = hitbox_manager.is_knockdown
	
	# Find direction to target from self
	vel_direction = target.get_parent().global_position - get_parent().global_position
	vel_direction = vel_direction.normalized()
	
	# Apply repeated attack effect
	if (hitbox_manager.attack_id == previous_attack_id):
		combo_counter += 1
		final_damage += combo_counter * repeat_attack_bonus
	else:
		combo_counter = 0
		previous_attack_id = hitbox_manager.attack_id
	
	# Apply final attack effects
	if (attack_queue.size() == 1):
		if (last_attack_ids.has(hitbox_manager.attack_id)):
			final_damage += last_attack_bonus
		elif (knockdown_last_attack_ids.has(hitbox_manager.attack_id)):
			is_knockdown = true
	
	# Relay info to target
	target.health_manager.get_damaged(
	final_damage, hitbox_manager.damage_type, 
	hitbox_manager.base_kb_distance, vel_direction, is_knockdown)

# Attack state: play next attack and remove 1 card
# Change to idle and reset combo if no more attacks are in queue
# Knocked Down state: Check if character's health is 0. 
# Engage death if true, change to idle if false
func _on_animation_player_animation_finished(anim_name):
	if (get_parent().view_state() == 2):
		attack_queue.remove_at(0)
		get_parent().node_card_manager.discard_front_card()
		
		if (attack_queue.size() > 0):
			play_next_attack()
		else:
			previous_attack_id = 0
			combo_counter = 0
			get_parent().change_state(0)
			play_idle()
	elif (get_parent().view_state() == 3):
		if (health_manager.view_health() <= 0):
			pass # Replace with calling death function
		else:
			get_parent().change_state(0)
			play_idle()
