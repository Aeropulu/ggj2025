extends Control

var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "0"
	Connect_Signaux()

func Connect_Signaux():
	EventManager._on_add_score.connect(_On_Score_Addition)

func _On_Score_Addition(addition : int):
	score += addition
	RuntimeData.current_score = score
	$Label.text = str(score)
