extends Node2D


@export var ammo = 20: set = _set_ammo

func _set_ammo(new_ammo: int):
	ammo = clamp(new_ammo,0 , 100)
	
