extends Node2D


@export var max_ammo = 20: set = _set_max_ammo

func _set_max_ammo(new_max_ammo: int):
	max_ammo = clamp(new_max_ammo,0 , 100)
	
