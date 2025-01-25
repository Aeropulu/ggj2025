extends Node

@export var char: Character
@export var action: ActionBase
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func  do_action() -> void:
	if (not is_instance_valid(char) or not is_instance_valid(action)):
		return
	action.do_action(char)
