extends Button
class_name ActionButton

@export var action: ActionBase:
	set(value):
		action = value
		action_icon.texture = value.icon
		

@export var bubble_scene : PackedScene
@export var character: Character
@export var preview: Preview
@export var action_icon:TextureRect
@export var deck:Deck
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(deck):
		action = deck.draw_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if (not is_instance_valid(character) or not is_instance_valid(action)):
		return
	action.do_action(character)
	if (is_instance_valid(preview)):
		preview.current_bubble = bubble_scene.instantiate()
	if is_instance_valid(deck):
		action = deck.draw_card(action)
		

func _on_mouse_entered() -> void:
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	pass # Replace with function body.
