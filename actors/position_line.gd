extends Line2D

@export var main_part:CharacterBody2D
@export var pos:CharacterBody2D

func _process(_delta: float) -> void:
	points[1] = pos.position
	if points[1].y < -20:
		visible = true
		return
	
	visible = false
