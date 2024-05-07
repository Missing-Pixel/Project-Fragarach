class_name CardManager
extends Node
## The complete manager script for playing cards in the game

# Prototype variables until deck building is finished
# DELETE WHEN REFACTORING
@export var punch_count = 0
@export var kick_count = 0
@export var heavy_punch_count = 0
@export var heavy_kick_count = 0


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
	
	# Draw a card and put it into each card slot
	for key in card_slots:
		rand_index = randi() % deck_pile.size()
		card_slots[key][0] = deck_pile[rand_index]
		deck_pile.remove_at(rand_index)
	
	card_state = CardState.QUEUE

# If in queue state, be able to (de)select cards
func _on_player_selected_card(card_slot_value):
	if (card_state == CardState.QUEUE):
		if (card_slots[card_slot_value][1] == false):
			card_slots[card_slot_value][1] = true
			card_queue.append(card_slot_value)
		else:
			card_slots[card_slot_value][1] = false
			card_queue.erase(card_slot_value)

# If in queue state, add the active card slots' attack IDs to the attack queue
func _on_player_started_combo():
	if (card_state == CardState.QUEUE):
		card_state = CardState.DISCARD
		for k in card_queue:
			## append card_slots[k][0] to attack handler's attack_queue 
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_deck()
	_draw_phase()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# In Discard state, if card queue empty change to Draw
	pass
	
	## ATK signal: In Discard state if attack queue is smaller than card queue:
			# move card from card queue to discard pile
	## KD signal: In player's KD state, empty card queue onto discard pile
