extends Node2D
class_name CameraManager
@onready var camera_2d: Camera2D = $Camera2D

var target:Node2D

func update_camera():
	if target:
		global_position = target.global_position
		return
