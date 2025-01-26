extends Node2D
class_name Character

@export var _tilemap: Board
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var move_duration: float
var bump_duration: float = 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_to(Vector2i(0, 8))
	move_duration = animation_player.get_animation("move").length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to(tile_coord: Vector2i) -> void:
	if (not is_instance_valid(_tilemap)):
		return
	var pos = _tilemap.to_global(_tilemap.map_to_local(tile_coord))
	var bubble = _tilemap.get_bubble(tile_coord)
	if is_instance_valid(bubble):
		die()
	
	animation_player.play("move")
	animation_player.animation_finished.connect(func(_name):animation_player.play("idle"))
	var move_tween := get_tree().create_tween()
	move_tween.tween_property(self, "global_position", pos, move_duration)

func get_tile_pos() -> Vector2i:
	if (not is_instance_valid(_tilemap)):
		return Vector2i.ZERO
	return _tilemap.local_to_map(_tilemap.to_local(self.global_position))

func advance() -> void:
	move_to(get_tile_pos() + Vector2i.UP)
	
func bump(direction: Vector2i) -> void:
	var vector: Vector2 = Vector2(direction * _tilemap.tile_set.tile_size) * 0.5
	var start_pos := global_position
	var bump_pos := global_position + vector
	var bump_tween := get_tree().create_tween()
	bump_tween.tween_property(self, "global_position", bump_pos, bump_duration * 0.5)
	bump_tween.tween_property(self, "global_position", start_pos, bump_duration * 0.5)

func shoot() -> void:
	animation_player.play("shoot")
	animation_player.animation_finished.connect(func(_name):animation_player.play("idle"))

func die() -> void:
	var tween = get_tree().create_tween()
	var transition_time = 0.1
	for i in range(4):
		tween.tween_property(self, "modulate", Color.RED, transition_time)
		tween.tween_property(self, "modulate", Color.WHITE, transition_time)
