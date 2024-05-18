extends Resource
## Dictonary table for enemy flags

@export var deaths: PackedInt32Array
@export var left_limits: PackedFloat64Array
@export var right_limits: PackedFloat64Array
@export var locked_flags: Array # should be bool

func _init(p_deaths = [], p_lefts = [], p_rights = [], p_locks = []):
	deaths = p_deaths
	left_limits = p_lefts
	right_limits = p_rights
	locked_flags = p_locks
