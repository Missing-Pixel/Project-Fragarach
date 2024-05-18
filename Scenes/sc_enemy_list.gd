class_name EnemyList
extends Node2D
## Main script to manage enemies. 
## All enemies and wave spawners should be children of List

signal enemy_flag_triggered(left_limit, right_limit, is_locked)


@export var enemy_max: int = 0
@export var enemy_flag_path: String

var enemy_death_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
