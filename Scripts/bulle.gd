extends Node2D
class_name Bulle

var board: Board = null
var matching_bubbles_parent: Node2D

@export var color_id: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func apply_anim() -> void:
	print("ploc")
	if is_instance_valid(matching_bubbles_parent):
		matching_bubbles_parent.queue_free()
