extends Node2D
class_name CameraManager

var target:Node2D

func update_camera():
	if target:
		global_position = target.global_position
		return
