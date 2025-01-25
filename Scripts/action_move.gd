extends ActionBase
class_name ActionMove

@export var relative_movement: Vector2i
@export var preview_arrow_scene: PackedScene = preload("res://Scenes/ActionPreviews/PreviewMove.tscn")

func do_action(char: Character)-> bool:
	char.move_to(char.get_tile_pos() + relative_movement)
	# TODO: check collisions
	return true

func make_preview(_char: Character)-> Node2D:
	var dir := Vector2(relative_movement)
	var angle = Vector2.RIGHT.angle_to(dir)
	var preview_node: Node2D = preview_arrow_scene.instantiate()
	if not is_instance_valid(preview_node):
		return null
	preview_node.rotation = angle
	return preview_node
