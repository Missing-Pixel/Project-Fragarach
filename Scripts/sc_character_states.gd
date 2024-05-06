class_name CharacterStates
extends Node
## Basic character state manager

enum States {IDLE=0, MOVING=1, ATTACKING=2, KNOCKED_DOWN=3}
@export var current_state: States = States.IDLE

# Change state through a function rather than a public variable
func change_state(new_state):
	current_state = new_state

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = States.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
