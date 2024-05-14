class_name Hitbox
extends Node
## Detects hurtbox of a target and communicates with parent 
## Has properties set in animator through a child data nodes

enum DamageType { NONE = 0, PUNCH = 1, KICK = 2 }

@export var attack_id: int
@export var base_damage: float
@export var damage_type: DamageType
@export var base_kb_distance: float
@export var is_knockdown: bool

var target: Node

# Apply hitbox properties (attack_ID, base damage, damage type, base kb distance, is knockdown)
func apply_properties(is_resetting:bool, input_node:Node = null):
	if (is_resetting == true or input_node == null):
		attack_id = 0
		base_damage = 0
		damage_type = DamageType.NONE
		base_kb_distance = 0
		is_knockdown = false
	else:
		attack_id = input_node.attack_id
		base_damage = input_node.base_damage
		damage_type = input_node.damage_type
		base_kb_distance = input_node.base_kb_distance
		is_knockdown = input_node.is_knockdown

# Search data nodes by its potential attack ID and add the correct one into the properties
func load_hitbox_data(n_atk_id: int):
	for c in get_children():
		if not(c is CollisionShape2D):
			if (c.attack_id == n_atk_id):
				apply_properties(false, c)
				break
