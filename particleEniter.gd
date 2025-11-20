extends Area2D

@export var particle:PackedScene
@export var queue_count:int = 8
var index:int = 0
func _ready() -> void:
	for i in queue_count:
		call_deferred("add_child",particle.instantiate())
		

func get_next_paticle():
	return get_child(index)

func trigger():
	get_next_paticle().restart()
	index = (index+1) % queue_count
