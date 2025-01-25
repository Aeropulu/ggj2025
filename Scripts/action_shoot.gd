extends ActionBase
class_name action_shoot

@export var bubble_scene: PackedScene
@export var direction: Vector2i = Vector2i.UP

func do_action(char: Character) -> bool:
	if (not is_instance_valid(bubble_scene)):
		return false
	var bubble_node: Bulle = bubble_scene.instantiate()
	bubble_node.position = char.position
	bubble_node.following_path = true
	var board: Board = char.get_node("%Board")
	bubble_node.board = board
	var path := board.calculate_path(char.get_tile_pos(), direction)
	path.add_child(bubble_node)
	return true
