extends Node2D


@export var reload = 20: set = _set_reload

func _set_reload(new_reload: int):
	reload = clamp(new_reload,0 , 100)
	
