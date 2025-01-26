extends Control

@export var images_tutoriel : Array[Texture2D]
@export var bouton : Button
@export var textRectTuto : TextureRect

var _avancee : int = 0

func _ready() -> void:
	MAJ_Visuelle_Tuto()
	bouton.pressed.connect(_On_Bouton_Pressed)

func _On_Bouton_Pressed():
	_avancee += 1
	if _avancee > images_tutoriel.size() -1 :
		self.queue_free()
		return
	MAJ_Visuelle_Tuto()

func MAJ_Visuelle_Tuto():
	textRectTuto.texture = images_tutoriel[_avancee]
