extends Node2D


@export var max_reload = 20: set = _set_max_reload

func _set_max_reload(new_max_reload: int):
	max_reload = clamp(new_max_reload,0 , 100)
	
