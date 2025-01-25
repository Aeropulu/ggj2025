extends Resource
class_name ActionBase

@export var icon:Texture2D

# Override this
func do_action(_char: Character)-> bool:
	return false

func make_preview(_char: Character)-> Node2D:
	return null
