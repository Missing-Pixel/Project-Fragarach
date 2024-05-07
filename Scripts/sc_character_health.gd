class_name CharacterHealth
extends Node
## Managing Character health and knockback, alongside recieving damage and dying

enum DamageType { NONE=0, PUNCH=1, KICK=2 }

@export var max_health: float = 100
@export_group("Damage Types")
@export var dmg_resist_type: DamageType = DamageType.NONE
@export_range(0, 1) var dmg_resist_potency: float = 0.5
@export var dmg_weak_type: DamageType = DamageType.NONE
@export var dmg_weakness_multiplier: float = 2
@export_group("Knockback")
@export var kb_resist: float = 0.5
@export var kb_pushtime: float = 0.02
@export var knockdown_airtime: float = 1

@onready var curr_health: float = max_health

# When receiving a damage signal, managethe health and knockback
func _on_damage_received(damage, damage_type_id, kb_distance, kb_direction, is_knockdown):
	var final_damage: float = damage
	var dmg_type_received: DamageType = damage_type_id
	var final_kb: float = kb_distance
	
	# Apply damage resist or weakness if possible, and then deal damage
	if (dmg_type_received != DamageType.NONE):
		if (dmg_resist_type == dmg_type_received):
			final_damage *= dmg_resist_potency
		elif (dmg_weak_type == dmg_type_received):
			final_damage *= dmg_weakness_multiplier
	curr_health -= final_damage
	
	# Death check
	
	# Knockdown check
	
	# Apply knockback
	
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
