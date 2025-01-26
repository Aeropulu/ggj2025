extends Node2D

var avancement : int = 0
@onready var sprite2D : Sprite2D = $Sprite2D
@export var images_avancement : Array[Texture2D]

func _ready() -> void:
	Match_Graphisme_Avec_Avancement()
	EventManager._on_new_board.connect(On_New_Board)

func On_New_Board():
	avancement += 1
	Match_Graphisme_Avec_Avancement()

func Match_Graphisme_Avec_Avancement():
	sprite2D.texture = images_avancement[avancement]
