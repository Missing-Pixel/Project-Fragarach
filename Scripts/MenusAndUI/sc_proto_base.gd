extends Node

@export var player_node: Node

func update_health():
	var hp = player_node.node_health_manager.curr_health
	$Health.text = "Player\nHealth: " + str(hp)

func update_attack_queue():
	var queue = player_node.node_action_manager.attack_queue
	var output_string = "Attacks: "
	
	if (queue.size() > 0):
		for i in queue:
			output_string += _id_to_string(i+1) + " "
		$AttackQueue.text = output_string
		$AttackQueue.show()
	else:
		$AttackQueue.hide()

func update_card_slots():
	var slots: Array = ["I", "J", "K", "L"]
	var slot_text: Array = [$Slot1, $Slot2, $Slot3, $Slot4]
	var slot_dict = player_node.node_card_manager.card_slots
	var output_text: String = ""
	
	for key in slot_dict:
		output_text = "Slot " + str(key) + " - " + str(slots[key-1]) + "\n"
		output_text += _id_to_string(slot_dict[key][0])
		if (slot_dict[key][1] == true):
			output_text += "\nSelected"
		slot_text[key-1].text = output_text

func update_card_combo():
	var card_queue = player_node.node_card_manager.card_queue
	var output_text = " "
	
	if (card_queue.size() > 0):
		output_text = "<Space>\nStart Combo\n"
		for i in card_queue:
			output_text += str(i) + " "
		$ReadyCombo.text = output_text
		$ReadyCombo.show()
	else:
		$ReadyCombo.hide()

func update_piles():
	var deck_count = player_node.node_card_manager.deck_pile.size()
	var discard_count = player_node.node_card_manager.discard_pile.size()
	var output_text = " "
	
	output_text = "Deck: " + str(deck_count) + "\n"
	output_text += "(Discard: " + str(discard_count) + ")"
	$DeckPiles.text = output_text

func _id_to_string(id: int):
	if (id == 0):
		return "Empty"
	elif (id == 1):
		return "Punch"
	elif (id == 2):
		return "Kick"
	elif (id == 3):
		return "H.Punch"
	elif (id == 4):
		return "H.Kick"
	else:
		return "???"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_attack_queue()
	update_card_combo()
	update_card_slots()
	update_health()
	update_piles()
	pass
