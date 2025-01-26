extends Node

var current_score : int = 0
var current_board : int = 0

func _ready() -> void:
	EventManager._on_new_board.connect(_On_New_Board)

func _On_New_Board():
	current_board += 1
