extends Node2D
class_name Bulle

var matching_bubbles_parent: Node2D
var falling_bubbles_parent: Node2D
@export var coussin_color: Color

@export var color_id: int = 0

@export var diamant_sprite: Node2D
@export var bulle_sprite: Node2D

@export var noise: Noise
@export var has_noise_anim: bool
var noise_amplitude:float = 0.1
var noise_dir: Vector2 = Vector2.RIGHT.rotated(0.2)
var noise_speed: float = 30

var phase: float
var time: float = 0.0
var amplitude: float = 0.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase = randf_range(0, 2 * PI)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(diamant_sprite):
		diamant_sprite.rotation = sin(time + phase) * amplitude
	if is_instance_valid(bulle_sprite) and has_noise_anim and is_instance_valid(noise) :
		var noise_input = global_position + noise_dir * time * noise_speed
		var noise_value = noise.get_noise_2dv(noise_input)
		bulle_sprite.scale = Vector2.ONE * (1 + noise_value * noise_amplitude)
	time += delta
	pass
		
func apply_anim() -> void:
	print("ploc")
	if is_instance_valid(matching_bubbles_parent):
		for bubble in matching_bubbles_parent.get_children():
			if bubble is Bulle:
				bubble.pop()

	if is_instance_valid(falling_bubbles_parent):
		get_tree().create_tween().tween_property(falling_bubbles_parent, "position", Vector2(0, 1000), 0.3)

func pop() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 2.0, 0.1)
	tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
	tween.finished.connect(queue_free)
	
func fall() -> void:
	pass
