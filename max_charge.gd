extends Node2D



@export var max_charge = 1: set = _set_max_charge

func _set_max_charge(new_max_charge: float):
	max_charge = clamp(new_max_charge,0 , 1000)
	
