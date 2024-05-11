extends Node

@export_group("Animation Names")
@export var anim_idle: String
@export var anim_move: String

# key = ID of attack (int)
# value = attack animation name (string) 
@export var anim_attacks: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
