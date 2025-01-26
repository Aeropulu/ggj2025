extends ActionBase
class_name ActionMove

@export var relative_movement: Vector2i
@export var preview_arrow_scene: PackedScene = preload("res://Scenes/ActionPreviews/PreviewMove.tscn")

func do_action(char: Character)-> bool:
	var board: Board = char.get_node("%Board")
	var next_pos: Vector2i = char.get_tile_pos() + relative_movement
	if next_pos.x < 0 or next_pos.y >= board.width:
		char.bump(relative_movement)
		return false
	
	char.move_to(next_pos)
	return true

func make_preview(char: Character)-> Node2D:
	var dir := Vector2(relative_movement)
	var angle = Vector2.RIGHT.angle_to(dir)
	var preview_node: Node2D = preview_arrow_scene.instantiate()
	if not is_instance_valid(preview_node):
		return null
	preview_node.rotation = angle
	var board: Board = char.get_node("%Board")
	preview_node.position = board.map_to_local(char.get_tile_pos())
	return preview_node
