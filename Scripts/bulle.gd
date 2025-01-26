extends Node2D
class_name Bulle

var matching_bubbles_parent: Node2D
var falling_bubbles_parent: Node2D
@export var coussin_color: Color

@export var color_id: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var board = get_parent()
	#if not board is Board:
		#return
	#print(board.local_to_map(position))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func apply_anim() -> void:
	print("ploc")
	if is_instance_valid(matching_bubbles_parent):
		matching_bubbles_parent.queue_free()
	if is_instance_valid(falling_bubbles_parent):
		get_tree().create_tween().tween_property(falling_bubbles_parent, "position", Vector2(0, 1000), 0.3)
