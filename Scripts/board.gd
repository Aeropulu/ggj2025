extends TileMapLayer
class_name Board

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
	var curve := Curve2D.new()
	curve.add_point(map_to_local(start_pos))
	var ended := false
	var pos := start_pos
	while (not ended):
		var next_pos := pos + direction
		if (next_pos.y < 0 or next_pos.y > height
				or next_pos.x < 0 or next_pos.x > width
				or get_bubble(next_pos) != null):
			ended = true
		else:
			curve.add_point(map_to_local(next_pos))
			print(get_cell_tile_data(next_pos))
			pos = next_pos
	path.curve = curve
	add_child(path)
	return path

func get_bubble(tile_coord: Vector2i) -> Bulle:
	var bulle: Bulle = null
	for child in get_children():
		if child is Bulle:
			bulle = child
		if (bulle != null and local_to_map(bulle.position) == tile_coord):
			return bulle
	return null
