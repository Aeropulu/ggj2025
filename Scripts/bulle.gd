extends PathFollow2D
class_name Bulle

var speed: int = 1000
var following_path = false
var board: Board = null
var matching_bubbles_parent: Node2D

var color_id: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not following_path:
		return
	progress += speed * delta
	if progress_ratio >= 1.0:
		var parent = get_parent()
		if (board != null):
			parent.remove_child(self)
			var bubble: Bulle = board.get_bubble(board.local_to_map(position))
			if is_instance_valid(bubble):
				bubble.visible = true
			else:
				apply_anim()
		if parent is Path2D:
			parent.queue_free()
		following_path = false
		
func apply_anim() -> void:
	print("ploc")
	matching_bubbles_parent.queue_free()
