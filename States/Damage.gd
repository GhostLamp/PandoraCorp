extends Node2D

@export var damage = 500: set = _set_damage

func _set_damage(new_damage: int):
	damage = clamp(new_damage,0 , 100000000)
	
