class_name CharacterHealth
extends Node
## Managing Character health and knockback, alongside recieving damage and dying

enum DamageType { NONE=0, PUNCH=1, KICK=2 }

@export var max_health: float = 100
@export var immunity_time: float = 0.6
@export var kb_resist: float = 0.5
@export var kb_death_multiplier: float = 2
@export_group("Damage Types")
@export var dmg_resist_type: DamageType = DamageType.NONE
@export_range(0, 1) var dmg_resist_potency: float = 0.5
@export var dmg_weak_type: DamageType = DamageType.NONE
@export var dmg_weakness_multiplier: float = 2

@export_group("Knockback")
@export var kb_push_time: float = 0.02
@export var knockdown_rise_time = 0.3
@export var knockdown_airtime: float = 1

@onready var curr_health: float = max_health
@onready var curr_immunity: float = immunity_time

# When receiving a damage signal, manage the health and knockback
func _on_damage_received(damage, damage_type_id, kb_distance, kb_direction, is_knockdown):
	if (curr_immunity < 0):
		var final_damage: float = damage
		var dmg_type_received: DamageType = damage_type_id
		var final_kb_distance: float = kb_distance * kb_resist
		
		# Apply damage resist or weakness if possible, and then deal damage
		if (dmg_type_received != DamageType.NONE):
			if (dmg_resist_type == dmg_type_received):
				final_damage *= dmg_resist_potency
			elif (dmg_weak_type == dmg_type_received):
				final_damage *= dmg_weakness_multiplier
		curr_health -= final_damage
		
		# Apply knockback
		## movement: knockback user (final_kb_distance, is_knockdown)
		## force is_knockdown to true when health < 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (curr_immunity >= 0):
		curr_immunity -= delta
	pass
