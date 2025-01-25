extends HBoxContainer
class_name Deck
@export var cards: Array[ActionBase]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = cards.filter(func(card): return is_instance_valid(card))
	print("cuicui")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card(return_card: ActionBase = null) -> ActionBase:
	if (cards.size() <= 0):
		return null
	var rand = randi_range(0, cards.size() - 1)
	var card = cards[rand]
	cards.remove_at(rand)
	if is_instance_valid(return_card):
		cards.push_back(return_card)
	return card
