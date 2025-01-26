extends ActionBase
class_name action_shoot

@export var directions: Array[Vector2i]
@export var delay_between_shots: float = 0.1

func do_action(char: Character) -> float:
	var preview: Preview = char.get_node("%Preview")
	if not is_instance_valid(preview):
		return 0.0
	
	var board: Board = char.get_node("%Board")
	
	var last_timer: SceneTreeTimer = null
	for dir in directions:
		var bubble_node: Bulle = preview.instantiate_bubble_node()
		if (not is_instance_valid(bubble_node)):
			continue
		bubble_node.position = Vector2.ZERO
		var curve := board.calculate_path(char.get_tile_pos(), dir)
		var path: Path2D = Path2D.new()
		path.curve = curve
		
		board.add_child(path)
		var carrier := BubbleCarrier.new()
		carrier.loop = false
		carrier.rotates = false
		carrier.cubic_interp = false
		carrier.add_child(bubble_node)
		path.add_child(carrier)
		
		var final_pos: Vector2 = curve.get_point_position(curve.point_count - 1)
		var tilemap_bubble: Bulle = bubble_node.duplicate()
		tilemap_bubble.position = final_pos
		tilemap_bubble.visible = false
		carrier.tilemap_bubble = tilemap_bubble
		board.add_child(tilemap_bubble)
		
		var matching_bubbles = board.get_matching_bubbles(board.local_to_map(final_pos))
		
		if matching_bubbles.size() >= board.min_to_match:
			var new_parent: Node2D = Node2D.new()
			board.add_child(new_parent)
			for bubble in matching_bubbles:
				board.remove_child(bubble)
				new_parent.add_child(bubble)
			tilemap_bubble.matching_bubbles_parent = new_parent
		
			var falling_bubbles = board.get_falling_bubbles()
			var falling_parent: Node2D = Node2D.new()
			board.add_child(falling_parent)
			for bubble in falling_bubbles:
				board.remove_child(bubble)
				falling_parent.add_child(bubble)
			tilemap_bubble.falling_bubbles_parent = falling_parent
		
		if last_timer == null:
			carrier.following_path = true
		else:
			last_timer.timeout.connect(func(): carrier.following_path = true)
		last_timer = board.get_tree().create_timer(delay_between_shots)
	return directions.size() * delay_between_shots

func make_preview(char: Character)-> Node2D:
	var board: Board = char.get_node("%Board")
	var preview_node := Node2D.new()
	for dir in directions:
		var curve := board.calculate_path(char.get_tile_pos(), dir)
		var line := Line2D.new()
		line.width = 4
		for i in range(0, curve.point_count):
			line.add_point(curve.get_point_position(i))
		preview_node.add_child(line)
	return preview_node
