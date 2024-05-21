class_name ObjectActionManager
extends Node
## General manager script for object's actions and animations
## Need to manually connect the following signals:
## AnimationPlayer - animation_finished
## Hitbox - body_entered

@export var attack_range: Node
@export var attack_cooldown: float = 0.1
@export_range(0, 1) var immunity_transparancy: float = 0.75
@export_group("Animation Names")
@export var anim_library: String
@export var anim_idle: String
@export var anim_move: String
@export var anim_knockdown: String
@export var anim_hitstun: String
@export var anim_death: String
# index = ID of attack (int)
# value = attack animation name (string) 
@export var anim_attacks: PackedStringArray

var anim_player: Node
var hitbox_manager: Node
var health_manager: Node
var attack_queue: Array = []
var attack_cooldown_timer: float = 0
var enable_immunity_activity: bool = true

@onready var characterSprite: Node = $CharacterSprite 

# Return count of number of attacks
func get_attack_count():
	return anim_attacks.size()

# Interrupt a currently playing animation to stun or knockdown
func interrupt_anim(is_knockdown: bool, keep_state: bool = true):
	anim_player.stop(keep_state)
	if (is_knockdown == true):
		play_knocked_down()
	else: 
		play_hitstun()

# Change sprite alpha whenever immunity is up or hitbox is disabled
func immunity_frames_visual():
	if (enable_immunity_activity):
		if ($Hurtbox.disabled == true) or (health_manager.curr_immunity > 0):
			characterSprite.set_self_modulate(Color(1, 1, 1, immunity_transparancy))
		else:
			characterSprite.set_self_modulate(Color(1, 1, 1, 1))

# Plays idle animation
func play_idle():
	_play_animation(anim_idle)

# Plays moving animation
func play_moving():
	_play_animation(anim_move)

# Plays an attacking animation
func play_next_attack():
	_play_animation(anim_attacks[0])

# Plays a knockdown animation
func play_knocked_down():
	_play_animation(anim_knockdown)

# Plays a hitstun animation
func play_hitstun():
	_play_animation(anim_hitstun)

# Plays death animation
func play_death():
	_play_animation(anim_death)

# Resumes any currently paused animations
# Mainly for Knocked down animation when it gets paused in animation
func resume_animation():
	anim_player.play()

# Add attack ID to queue. If applicable, change parent character state to ATTACKING and start anim
func add_attack(attack_id):
	if (get_parent().view_state() < 2 and attack_queue.is_empty()):
		attack_queue.append(attack_id)
		get_parent().change_state(2)
		play_next_attack()
	else:
		attack_queue.append(attack_id)

# Emit signal from parent character script to say that character died
func emit_death():
	var parent_node = get_parent()
	
	characterSprite.set_modulate(Color(1, 1, 1, 0))
	parent_node.character_died.emit(parent_node)

# General play animation function
func _play_animation(anim_file_name):
	var anim_path = anim_library + "/" + anim_file_name
	anim_player.play(anim_path)

# Relaying damage and knockback values to target's health manager
func _relay_info(target):
	# Find direction to target from self
	var vel_direction: Vector2
	vel_direction = target.get_parent().global_position - get_parent().global_position
	vel_direction = vel_direction.normalized()
	
	# Relay info to target
	target.health_manager.get_damaged(
	hitbox_manager.base_damage, hitbox_manager.damage_type, 
	hitbox_manager.base_kb_distance, vel_direction, hitbox_manager.is_knockdown)

# Remove latest attack and card. Play next attack, otherwise change to idle if no more
func _cycle_attack():
	attack_queue.remove_at(0)
	
	if (attack_queue.size() > 0):
		play_next_attack()
	else:
		get_parent().change_state(0)
		play_idle()

# Empty attack queue and switch to idle state
func _reset_attacks():
	attack_queue.clear()
	get_parent().change_state(0)
	play_idle()

# Attacking: Cycle attack
# if Knocked Back: Reset kb and immunity. If not knocked down or attacking, reset to idle
#    if Knocked Down: If health is 0, engage death. Otherwise, reset immunity and attacks
func _on_animation_player_animation_finished(anim_name):
	if (get_parent().view_state() == 2):
		_cycle_attack()
	if (get_parent().node_move_manager.get_is_knocked_back() == true):
		get_parent().node_move_manager.reset_kb()
		get_parent().node_health_manager.reset_immunity()
		if (get_parent().view_state() == 3):
			if (health_manager.view_health() <= 0):
				enable_immunity_activity = false
				play_death()
			else:
				_reset_attacks()
		elif (get_parent().view_state() != 2):
			get_parent().change_state(0)
			play_idle()

# When hitbox connects, and target's base collision is in attack range,
# relay information to target
func _on_hitbox_body_entered(body):
	if (body != self) and (attack_cooldown_timer >= attack_cooldown):
		if (attack_range.get_overlapping_bodies().has(body.get_parent())):
			_relay_info(body)


# Called when the node enters the scene tree for the first time.
func _ready(): 
	for c in get_children():
		if (c is AnimationPlayer):
			anim_player = c
		elif (c is Area2D):
			hitbox_manager = c
	await get_tree().create_timer(0.1).timeout
	health_manager = get_parent().node_health_manager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Reduce attack cooldown
	if (attack_cooldown_timer < attack_cooldown):
		attack_cooldown_timer += delta
