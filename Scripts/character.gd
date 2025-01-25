extends Node2D
class_name Character

@export var _tilemap: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_to(Vector2i(4, 8))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to(tile_coord: Vector2i) -> void:
	if (not is_instance_valid(_tilemap)):
		return
	var pos = _tilemap.map_to_local(tile_coord)
	self.position = pos

func get_tile_pos() -> Vector2i:
	if (not is_instance_valid(_tilemap)):
		return Vector2i.ZERO
	return _tilemap.local_to_map(self.position)
