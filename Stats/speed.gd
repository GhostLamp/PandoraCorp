extends Node2D


@export var speed = float(500): set = _set_speed

func _set_speed(new_speed: int):
	speed = clamp(new_speed,0 , 100000000)
	
