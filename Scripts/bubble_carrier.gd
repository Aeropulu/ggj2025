extends PathFollow2D
class_name BubbleCarrier

var speed: int = 1000
var following_path = false
var tilemap_bubble: Bulle = null

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
		if parent is Path2D:
			parent.queue_free()
		following_path = false
		if is_instance_valid(tilemap_bubble):
			tilemap_bubble.visible = true
			tilemap_bubble.apply_anim()
