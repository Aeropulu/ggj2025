extends Node

## Ajout de score
signal _on_add_score(add : int)
func Invoke_On_Add_Score(add : int):
	_on_add_score.emit(add)
