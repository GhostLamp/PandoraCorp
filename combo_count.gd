extends Node

@export var comboCount: float = 0
var max_combo = 0

func setCombo(new_combo):
	if new_combo > max_combo:
		max_combo = new_combo
	
	comboCount = max_combo

func reset():
	comboCount = 0
	max_combo = 0
