extends Resource

enum DamageType { NONE = 0, PUNCH = 1, KICK = 2 }

@export var base_damage: float
@export var damage_type: DamageType
@export var base_kb_distance: float
@export var is_knockdown: bool

func _init(p_damage = 1, p_damage_type = DamageType.NONE, p_kb_distance = 0, p_is_knockdown = false):
	base_damage = p_damage
	damage_type = p_damage_type
	base_kb_distance = p_kb_distance
	is_knockdown = p_is_knockdown
