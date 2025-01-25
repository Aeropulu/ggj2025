extends ActionBase
class_name action_shoot

@export var bubble_scene: PackedScene

func do_action(char: Character) -> bool:
	if (not is_instance_valid(bubble_scene)):
		return false
	var bubble_node: Bulle = bubble_scene.instantiate()
	bubble_node.position = char.position
	bubble_node.velocity = Vector2.UP * 200.0
	char.get_tree().root.add_child(bubble_node)
	return true
