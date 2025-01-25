extends TileMapLayer

var width: int = 8
var height: int = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calculate_path(start_pos: Vector2i, direction: Vector2i) -> Path2D:
	var path := Path2D.new()
	var ended := false
	var pos := start_pos
	while (not ended):
		var next_pos := pos + direction
		if (next_pos.y < 0 or next_pos.y > height
				or next_pos.x < 0 or next_pos.x > width):
			ended = true
	return path
