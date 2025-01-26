extends Node2D
class_name Game

static var current_board: Board


func switch_board(new_board_scene: PackedScene) -> void:
	var new_board: Board = new_board_scene.instantiate()
	if not is_instance_valid(new_board):
		printerr("invalid new board")
		return
	add_child(new_board)
	new_board.transform = current_board.transform
	current_board.queue_free()
	current_board = new_board
	current_board.name = "Board"
	current_board.unique_name_in_owner = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_board = %Board
	switch_board(load("res://Scenes/Boards/Board_Tuto_01.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
