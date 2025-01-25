extends ActionBase
class_name action_shoot

@export var bubble_scene: PackedScene

@export var directions: Array[Vector2i]
@export var delay_between_shots: float = 0.1

func do_action(char: Character) -> bool:
	if (not is_instance_valid(bubble_scene)):
		return false
	
	var board: Board = char.get_node("%Board")
	
	var last_timer: SceneTreeTimer = null
	for dir in directions:
		var bubble_node: Bulle = bubble_scene.instantiate()
		bubble_node.position = Vector2.ZERO
		bubble_node.board = board
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

		if last_timer == null:
			carrier.following_path = true
		else:
			last_timer.timeout.connect(func(): carrier.following_path = true)
		last_timer = board.get_tree().create_timer(delay_between_shots)

	return true
