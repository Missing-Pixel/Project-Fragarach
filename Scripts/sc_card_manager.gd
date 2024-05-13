class_name CardManager
extends Node
## The complete manager script for playing cards in the game

# Prototype variables until deck building is finished
# DELETE WHEN REFACTORING
@export_group("Prototype")
@export var punch_count = 2
@export var kick_count = 2
@export var heavy_punch_count = 2
@export var heavy_kick_count = 2
@export_group("")

signal added_attack(attack_id)
enum CardState { DRAW, QUEUE, DISCARD } 
enum CardAttacks { PUNCH=1, KICK=2, HEAVY_PUNCH=3, HEAVY_KICK=4}
var card_state: CardState = CardState.DRAW
var deck_pile: Array = []
var card_slots = {
	1: [0, false], 
	2: [0, false], 
	3: [0, false], 
	4: [0, false]
	}
var card_queue: Array = []
var discard_pile: Array = []

# If in queue state, be able to (de)select cards
func select_card(card_slot_value):
	if (card_state == CardState.QUEUE):
		if (card_slots[card_slot_value][1] == false):
			card_slots[card_slot_value][1] = true
			card_queue.append(card_slot_value)
		else:
			card_slots[card_slot_value][1] = false
			card_queue.erase(card_slot_value)

# If in queue state, add the active card slots' attack IDs to the attack queue
func start_combo():
	if (card_state == CardState.QUEUE):
		for k in card_queue:
			get_parent().node_action_manager.add_attack(card_slots[k][0]-1)
		card_state = CardState.DISCARD

# Remove latest card slot in queue and send it to discard pile.
# Change card state to DRAW is queue is empty 
func discard_front_card():
	var k: int = card_queue[0]
	discard_pile.append(card_slots[k][0])
	card_slots[k][0] = 0
	card_slots[k][1] = false
	card_queue.remove_at(0)
	if card_queue.is_empty():
		card_state = CardState.DRAW
		_draw_phase()

# Empty entire card queue and put it into discard pile
func empty_card_queue():
	while not(card_queue.is_empty()):
		discard_front_card()

# Create deck based on count of each card type
# REFACTOR ONCE DECK BUILDING FINISHED
func _create_deck():
	for i in range(punch_count):
		deck_pile.append(CardAttacks.PUNCH)
	for i in range(kick_count):
		deck_pile.append(CardAttacks.KICK)
	for i in range(heavy_punch_count):
		deck_pile.append(CardAttacks.HEAVY_PUNCH)
	for i in range(heavy_kick_count):
		deck_pile.append(CardAttacks.HEAVY_KICK)

# Draw cards and put them into the four card slots
func _draw_phase():
	var rand_index: int = 0
	
	# If deck_pile size < 4, pull from discard_pile
	if (deck_pile.size() < 4):
		deck_pile += discard_pile
		discard_pile.clear()
	
	# If card slot is empty, draw a card and put it into each card slot
	for key in card_slots:
		if (card_slots[key][0] == 0):
			rand_index = randi_range(0, deck_pile.size()-1)
			card_slots[key][0] = deck_pile[rand_index]
			deck_pile.remove_at(rand_index)
	
	card_state = CardState.QUEUE

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_deck()
	_draw_phase()
