extends Node2D
class_name Game

static var current_board: Board
static var instance: Game

@export var levels: Array[PackedScene]
var current_level = 0
@onready var victory_screen = preload("res://Scenes/Ecran_Victoire.tscn")

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
	instance = self
	current_board = %Board
	switch_board(levels[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func next_level() -> void:
	instance.current_level += 1
	if instance.current_level >= instance.levels.size():
		win_game()
		return
	var level_scene = instance.levels[instance.current_level]
	instance.switch_board(level_scene)
	EventManager.Invoke_On_New_Board()
	

static func fail_level() -> void:
	instance.switch_board(instance.levels[instance.current_level])
	AudioManager.Wrong(1.0)
	
static func win_game() -> void:
	instance.add_child(instance.victory_screen.instantiate())
	AudioManager.Pop_Button(1.0)
