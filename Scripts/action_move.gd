extends ActionBase
class_name ActionMove

@export var relative_movement: Vector2i

func do_action(char: Character)-> bool:
	char.move_to(char.get_tile_pos() + relative_movement)
	# TODO: check collisions
	return true
