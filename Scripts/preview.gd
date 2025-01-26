extends Node2D
class_name Preview

@export var bubbles: Array[PackedScene]
@export var coussin: Sprite2D
var spawn_duration: float = 0.25
var mouse_pos: Vector2

var current_bubble: Bulle = null:
	set(value):
		if is_instance_valid(current_bubble):
			current_bubble.queue_free()
		current_bubble = value
		add_child(current_bubble)
		coussin.self_modulate = current_bubble.coussin_color
		current_bubble.scale = Vector2.ONE * 0.4
		current_bubble.global_position = mouse_pos
		var tween = get_tree().create_tween()
		tween.tween_property(current_bubble, "global_position", global_position, spawn_duration)
		tween.parallel().tween_property(current_bubble, "scale", Vector2.ONE, spawn_duration)
		
var current_id: int = bubbles.size() + 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_pos = get_viewport_rect().end
	random_bubble()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func random_bubble() -> void:
	var bubbles_count = bubbles.size()
	var rand = randi_range(0, bubbles_count - 1)
	if rand == current_id:
		rand = randi_range(0, bubbles_count - 1)
	current_id = rand
	if is_instance_valid(current_bubble):
		current_bubble.queue_free()
	current_bubble = bubbles[current_id].instantiate()

func instantiate_bubble_node() -> Bulle:
	if not is_instance_valid(current_bubble):
		random_bubble()
		if not is_instance_valid(current_bubble):
			return null
	var bubble = current_bubble.duplicate()
	if not bubble is Bulle:
		return null
	return bubble
