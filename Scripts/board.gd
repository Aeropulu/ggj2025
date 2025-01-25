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

func calculate_path(start_pos: Vector2i, direction: Vector2i, node_to_add: Node2D = null) -> Path2D:
	var path := Path2D.new()
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
		else:
			curve.add_point(map_to_local(next_pos))
			pos = next_pos
	path.curve = curve
	add_child(path)
	var new_node: Node2D = node_to_add.duplicate()
	new_node.position = map_to_local(pos)
	new_node.visible = false
	add_child(new_node)
	if new_node is Bulle:
		var matching_bubbles:Array[Bulle] = get_matching_bubbles(pos)
		if matching_bubbles.size() >= min_to_match:
			var new_parent: Node2D = Node2D.new()
			add_child(new_parent)
			for bubble in matching_bubbles:
				remove_child(bubble)
				new_parent.add_child(bubble)
			node_to_add.matching_bubbles_parent = new_parent
	return path

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
