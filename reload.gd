extends Node
class_name Reload

@export var reload:float  = 20: set = _set_reload
@export var max_reload:float = 1

func _set_reload(new_reload: float):
	reload = clamp(new_reload,0 , max_reload)
	
