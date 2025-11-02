extends Node2D
class_name Health

@export var max_health: float 
@export var health:float : set = _set_health

func _ready() -> void:
	max_health = health


func _set_health(new_health: float):
	health = clampf(new_health,0 , 1000)
	
