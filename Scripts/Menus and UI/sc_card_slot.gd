class_name CardSlot
extends Node
## Manages the animations and visuals of the card slot

@export var slot_id: int
@export_category("Aniamtions")
@export var anim_library: String = "Card"
@export var anim_draw: String = "drawing"
@export var anim_select: String = "select"
@export var anim_deselect: String = "deselect"
@export var anim_discard: String = "discard"

var is_empty: bool = true
var is_selected: bool = false
var current_card: int = 0
var player_card_node: Node

@onready var card_sprite = $Card
@onready var animation_player = $AnimationPlayer

# Connect player's card manager signal to this slot
func connect_player(card_manager):
	player_card_node = card_manager
	card_manager.card_slot_changed.connect(_on_card_slot_changed)

# Reset card visual from discard animation
func reset_card_visual():
	card_sprite.frame = 0

# Change card state based on signal received
func _on_card_slot_changed(id: int, select_state: bool, is_discarding: bool = false, card_id: int = current_card):
	if (slot_id == id):
		if (is_empty == true):
			_draw_card(card_id)
		else:
			if (is_discarding == true):
				_discard_card()
			elif (is_selected != select_state):
				is_selected = select_state
				_play_card_selection(select_state)

# Draw card by setting card visual and animate it
func _draw_card(card_id: int):
	# Where are the heavy cards???????
	var id_mod = (card_id%2) + 1
	card_sprite.frame = id_mod
	
	is_empty = false
	is_selected = false
	_play_animation(anim_draw)


# Discard card by playing animation
func _discard_card():
	is_empty = true
	is_selected = false
	_play_animation(anim_discard)

# Play selection or deselection animation depending on value received
func _play_card_selection(select_state):
	if (select_state == true):
		_play_animation(anim_select)
		Audio_Manager.play_sound("SFX_Card")
	else:
		_play_animation(anim_deselect)

# General play animation function
func _play_animation(anim_file_name):
	var anim_path = anim_library + "/" + anim_file_name
	animation_player.play(anim_path)

# Check state of card manager. If in draw state, emable their draw phase
func _on_card_animation_finished(anim_name):
	if (player_card_node != null):
		if (player_card_node.card_state == 0):
			player_card_node._draw_phase()
