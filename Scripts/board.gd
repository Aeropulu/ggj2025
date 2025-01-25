extends TileMapLayer
class_name Board

var width: int = 8
var height: int = 16
var min_to_match: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calculate_path(start_pos: Vector2i, direction: Vector2i) -> Curve2D:
	var curve := Curve2D.new()
	curve.add_point(map_to_local(start_pos))
	var ended := false
	var pos := start_pos
	while (not ended):
		var next_pos := pos + direction
		if next_pos.x < 0:
			direction.x = -direction.x
			next_pos.x = -next_pos.x	
		elif next_pos.x > width:
			direction.x = -direction.x
			next_pos.x = width - (next_pos.x - width)
			
		if (next_pos.y < 0 or next_pos.y > height
				or get_bubble(next_pos) != null):
			ended = true
		
		if direction.x != 0 and direction.y != 0:
			if (get_bubble(pos + Vector2i(0, direction.y)) != null
					and get_bubble(pos + Vector2i(direction.x, 0)) != null):
				ended = true
		if not ended:
			curve.add_point(map_to_local(next_pos))
			pos = next_pos
	return curve

func get_bubble(tile_coord: Vector2i) -> Bulle:
	var bulle: Bulle = null
	for child in get_children():
		if child is Bulle:
			bulle = child
		if (bulle != null and local_to_map(bulle.position) == tile_coord):
			return bulle
	return null

var cardinals: Array[Vector2i] = [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]

func get_matching_bubbles(tile_coord: Vector2i) -> Array[Bulle]:
	var open: Array[Bulle] = []
	var closed: Array[Bulle] = []
	var match_type: Bulle = get_bubble(tile_coord)
	var id_to_match: int = match_type.color_id
	open.push_back(match_type)
	while open.size() > 0:
		var bubble: Bulle = open.pop_front()
		if not is_instance_valid(bubble):
			continue
		if bubble.color_id != id_to_match:
			continue
		if closed.has(bubble):
			continue
		closed.push_back(bubble)
		var map_pos: Vector2i = local_to_map(bubble.position)
		for dir in cardinals:
			var bubble_to_add = get_bubble(map_pos + dir)
			open.push_back(bubble_to_add)
		
	return closed
	
var cardinals_and_diagonals: Array[Vector2i] = [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT, 
			Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)]

func get_falling_bubbles() -> Array[Bulle]:
	var result: Array[Bulle] = []
	for node in get_children():
		if node is Bulle:
			result.push_back(node)
			
	var safe: Array[Bulle] = []
	var open: Array[Bulle] = []
	for i in range(0, width):
		var bubble = get_bubble(Vector2i(i, 0))
		if is_instance_valid(bubble):
			open.push_back(bubble)
			
	while open.size() > 0:
		var bubble = open.pop_front()
		if not safe.has(bubble):
			safe.push_back(bubble)
			
		var pos: Vector2i = local_to_map(bubble.position)
		for direction in cardinals_and_diagonals:
			var safe_bubble: Bulle = get_bubble(pos + direction)
			if is_instance_valid(safe_bubble):
				if not safe.has(safe_bubble) and not open.has(safe_bubble):
					open.push_back(safe_bubble)
				
	for safe_bubble in safe:
		var id = result.find(safe_bubble)
		if id != -1:
			result.remove_at(id)
			
		
	
	return result
