extends Node2D
class_name StatusManager

@export var status : Array = []



func new_effect(effect):
	if get_child_count() > 0:
		for effects in status:
			if effects.status_type == effect.status_type:
				return
	add_child(effect)
	status.append(effect)
	
