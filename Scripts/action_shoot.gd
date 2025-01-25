extends ActionBase
class_name action_shoot

@export var bubble_scene: PackedScene

@export var directions: Array[Vector2i]
@export var delay_between_shots: float = 0.1

func do_action(char: Character) -> bool:
	if (not is_instance_valid(bubble_scene)):
		return false
	
	var board: Board = char.get_node("%Board")
	
	var exclusions: Array[Vector2i] = []
	var last_timer: SceneTreeTimer = null
	for dir in directions:
		var bubble_node: Bulle = bubble_scene.instantiate()
		bubble_node.position = char.position
		bubble_node.board = board
		var path := board.calculate_path(char.get_tile_pos(), dir, bubble_node)
		path.add_child(bubble_node)
		var point: Vector2 = path.curve.get_point_position(path.curve.point_count - 1)
		exclusions.push_back(board.local_to_map(point))
		if last_timer == null:
			bubble_node.following_path = true
		else:
			last_timer.timeout.connect(func(): bubble_node.following_path = true)
		last_timer = board.get_tree().create_timer(delay_between_shots)

	return true
