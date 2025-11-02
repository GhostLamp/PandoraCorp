extends Node
class_name  Ammo

@export var ammo:float  = 20: set = _set_ammo
@export var max_ammo:float = 20

func _set_ammo(new_ammo: float):
	ammo = clamp(new_ammo,0 , 100)
	
