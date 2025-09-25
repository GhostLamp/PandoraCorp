extends Node2D


func _unhandled_input(_event):
	var mouse = get_global_mouse_position()
	look_at(mouse)
