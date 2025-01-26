extends Control

@onready var label : Label = $Label
@onready var button_quit : Button = $Button_Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MAJ_Score()
	Connect_Signals()

func MAJ_Score():
	label.text = str(RuntimeData.current_score)

func Connect_Signals():
	button_quit.pressed.connect(_On_Button_Quit_Pressed)

func _On_Button_Quit_Pressed():
	get_tree().quit()
