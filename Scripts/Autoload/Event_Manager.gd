extends Node

## Ajout de score
signal _on_add_score(add : int)
func Invoke_On_Add_Score(add : int):
	_on_add_score.emit(add)
	
## Nouveau Board
signal _on_new_board()
func Invoke_On_New_Board():
	_on_new_board.emit()
