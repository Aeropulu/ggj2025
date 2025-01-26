extends Node2D
class_name Character

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bubble_holder: Node2D = $BubbleHolder

signal on_die
var is_dead: bool = false

var move_duration: float
var bump_duration: float = 0.2

var is_high_emergency: bool = false
var music_emergency_lvl1 = preload("res://Assets/Audio/GGJ SOGAMES - MDC - PireRates Emergency lvl1.mp3")
var music_emergency_lvl2 = preload("res://Assets/Audio/GGJ SOGAMES - MDC - PireRates Emergency lvl2.mp3")

var held_bubble:Bulle

@export var board: Board
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_to_start()
	move_duration = animation_player.get_animation("move").length

func move_to_start() -> void:
	if (not is_instance_valid(board)):
		board = Game.current_board
	move_to(Vector2i((board.width - 1)  / 2, board.height))
	AudioManager.Stop(AudioManager.Bus.MUSIQUE)
	AudioManager.Play(music_emergency_lvl1, AudioManager.Bus.MUSIQUE)
	is_high_emergency = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to(tile_coord: Vector2i) -> void:
	if (not is_instance_valid(board)):
		board = Game.current_board
	var pos = board.to_global(board.map_to_local(tile_coord))
	if tile_coord.y < 6 and not is_high_emergency:
		is_high_emergency = true
		AudioManager.Stop(AudioManager.Bus.MUSIQUE)
		AudioManager.Play(music_emergency_lvl2, AudioManager.Bus.MUSIQUE)
	
	var bubble = board.get_bubble(tile_coord)
	if is_instance_valid(bubble):
		bubble.queue_free()
		die()
	
	animation_player.play("move")
	animation_player.animation_finished.connect(func(_name):animation_player.play("idle"))
	var move_tween := get_tree().create_tween()
	move_tween.tween_property(self, "global_position", pos, move_duration)
	if tile_coord.y < 0:
		finish_level(tile_coord.x)

func get_tile_pos() -> Vector2i:
	if (not is_instance_valid(board)):
		board = Game.current_board
	return board.local_to_map(board.to_local(self.global_position))

func advance() -> void:
	if (is_dead):
		return
	move_to(get_tile_pos() + Vector2i.UP)
	
func bump(direction: Vector2i) -> void:
	board = Game.current_board
	var vector: Vector2 = Vector2(direction * board.tile_set.tile_size) * 0.5
	var start_pos := global_position
	var bump_pos := global_position + vector
	var bump_tween := get_tree().create_tween()
	bump_tween.tween_property(self, "global_position", bump_pos, bump_duration * 0.5)
	bump_tween.tween_property(self, "global_position", start_pos, bump_duration * 0.5)

func shoot() -> void:
	animation_player.play("shoot")
	animation_player.animation_finished.connect(func(_name):animation_player.play("idle"))

func die() -> void:
	is_dead = true
	var tween = get_tree().create_tween()
	var transition_time = 0.1
	for i in range(4):
		tween.tween_property(self, "modulate", Color.RED, transition_time)
		tween.tween_property(self, "modulate", Color.WHITE, transition_time)
	await tween.finished
	is_dead = false
	Game.fail_level()
	move_to_start()

func finish_level(column: int) -> void:
	board = Game.current_board
	var reward: Reward = board.get_reward(column)
	if not is_instance_valid(reward) or reward.kill_player:
		die()
		return
	var score: int = reward.score
	EventManager.Invoke_On_Add_Score(score)
	Game.next_level()
	move_to_start()

func preview_bubble(bubble: Bulle) -> void:
	if is_instance_valid(held_bubble):
		held_bubble.queue_free()
	bubble_holder.add_child(bubble)
	bubble.position = Vector2.DOWN * 100
	var tween = get_tree().create_tween()
	tween.tween_property(bubble, "position", Vector2.ZERO, 0.15)
	bubble.scale = Vector2.ONE
	held_bubble = bubble
