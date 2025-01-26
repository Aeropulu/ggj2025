extends Resource
class_name ActionBase

@export var icon:Texture2D

# Override this
func do_action(_char: Character)-> float:
	return 0.0

func make_preview(_char: Character)-> Node2D:
	return null
