extends Area2D

@export var burning :PackedScene

func on_fire():
	var burn = burning.instantiate()
	get_parent().status_manager.new_effect(burn)
