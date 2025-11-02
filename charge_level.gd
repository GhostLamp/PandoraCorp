extends Node
class_name ChargeLevel


@export var charge:float  = 0 : set = _set_charge
@export var max_charge:float  = 1

func _set_charge(new_charge: float):
	charge = clamp(new_charge,0 , max_charge*1.2)
	
