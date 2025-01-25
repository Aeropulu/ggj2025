extends ActionBase
class_name action_shoot

@export var bubble_scene: PackedScene

func do_action(char: Character) -> bool:
	if (not is_instance_valid(bubble_scene)):
		return false
	var bubble_node: Bulle = bubble_scene.instantiate()
	bubble_node.position = char.position
	var board: Board = char.get_node("%Board")
	var path := board.calculate_path(char.get_tile_pos(), Vector2i.UP)
	path.add_child(bubble_node)
	return true
