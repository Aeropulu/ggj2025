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

var action_preview:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(deck):
		action = deck.draw_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	_on_mouse_exited()
	if (not is_instance_valid(character) or not is_instance_valid(action)):
		return
	preview.mouse_pos = get_viewport().get_mouse_position()
	deck.set_buttons_enable(false)
	var action_duration:float = action.do_action(character)
	await get_tree().create_timer(action_duration).timeout
	if (is_instance_valid(preview)):
		var preview_bubble = bubble_scene.instantiate()
		preview.current_bubble = preview_bubble
	if is_instance_valid(deck):
		action = deck.draw_card(action)
	
	character.advance()
	await get_tree().create_timer(character.move_duration).timeout
	deck.set_buttons_enable(true)

func _on_mouse_entered() -> void:
	_on_mouse_exited()
	action_preview = action.make_preview(character)
	if is_instance_valid(action_preview):
		Game.current_board.add_child(action_preview)


func _on_mouse_exited() -> void:
	if is_instance_valid(action_preview):
		action_preview.queue_free()
