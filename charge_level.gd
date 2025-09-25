extends Node2D



@export var charge = 0 : set = _set_charge

func _set_charge(new_charge: float):
	charge = clamp(new_charge,0 , 1000)
	
