extends Resource
class_name ActionBase

@export var icon:Texture2D
signal action_done

# Override this
func do_action(_char: Character)-> bool:
	action_done.emit()
	return false

func make_preview(_char: Character)-> Node2D:
	return null
