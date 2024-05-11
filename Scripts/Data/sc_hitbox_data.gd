extends Node

enum DamageType { NONE = 0, PUNCH = 1, KICK = 2 }

@export var attack_id: int
@export var base_damage: float
@export var damage_type: DamageType
@export var base_kb_distance: float
@export var is_knockdown: bool

func _init(p_atk_id = 0, p_dmg = 1, p_dmg_type = DamageType.NONE, p_kb_dist = 0, p_knockdwn = false):
	attack_id = p_atk_id
	base_damage = p_dmg
	damage_type = p_dmg_type
	base_kb_distance = p_kb_dist
	is_knockdown = p_knockdwn
