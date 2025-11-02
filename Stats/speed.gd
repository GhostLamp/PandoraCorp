extends Node
class_name SpeedStat

@export var speed = float(500): set = _set_speed
@export var accel = 6000
@export var friction = 8000
var current_speed:float


func _set_speed(new_speed: int):
	speed = clamp(new_speed,0 , 100000000)
	
