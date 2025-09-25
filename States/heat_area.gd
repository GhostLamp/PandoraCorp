extends Area2D

@export var heatead :PackedScene

func on_fire():
	var burn = heatead.instantiate()
	get_parent().status_manager.call_deferred("add_child", burn)
