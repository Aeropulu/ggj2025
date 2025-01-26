extends Control

@export var _bouton_play : Button
@export var _skip_button : TextureButton
@export var _animation_player : AnimationPlayer

func _ready() -> void:
	Connect_Signaux()

func Connect_Signaux():
	_bouton_play.pressed.connect(_On_Bouton_Pressed)
	_skip_button.pressed.connect(_On_Bouton_Skip_Pressed)
	
func _On_Bouton_Pressed():
	_animation_player.play("Introduction")

func _On_Bouton_Skip_Pressed():
	_Go_To_Game_Scene()

func Play_Music():
	AudioManager.Play(load())

func _Go_To_Game_Scene():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
