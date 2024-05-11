class_name Hitbox
extends Node
## Detects hurtbox of a target and communicates with parent 
## Has properties set in animator through a child Resource

enum DamageType { NONE = 0, PUNCH = 1, KICK = 2 }

@export var attack_id: int
@export var base_damage: float
@export var damage_type: DamageType
@export var base_kb_distance: float
@export var is_knockdown: bool

var target: Node

# Search Resources by its potential attack ID and add the correct one into the properties
func load_hitbox_data(n_atk_id: int):
	for c in get_children():
		if not(c is CollisionShape2D) and (c.attack_id == n_atk_id):
			attack_id = c.attack_id
			base_damage = c.base_damage
			damage_type = c.damage_type
			base_kb_distance = c.base_kb_distance
			is_knockdown = c.is_knockdown
			break
