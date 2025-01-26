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

var board: Board
var action_preview:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(deck):
		action = deck.draw_card()
		board = deck.get_node("%Board")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if (not is_instance_valid(character) or not is_instance_valid(action)):
		return
	action.do_action(character)
	await get_tree().create_timer(0.2).timeout
	if (is_instance_valid(preview)):
		preview.current_bubble = bubble_scene.instantiate()
	if is_instance_valid(deck):
		action = deck.draw_card(action)
	_on_mouse_exited()
	character.advance()
	_on_mouse_entered()
	

func _on_mouse_entered() -> void:
	action_preview = action.make_preview(character)
	if is_instance_valid(action_preview):
		board.add_child(action_preview)


func _on_mouse_exited() -> void:
	if is_instance_valid(action_preview):
		action_preview.queue_free()
