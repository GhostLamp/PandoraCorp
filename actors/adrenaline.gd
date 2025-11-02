extends Node

@export var adrenaline = 100: set = _set_adrenaline

func _set_adrenaline(new_adrenaline: float):
	adrenaline = clamp(new_adrenaline,0 , 100)
	
