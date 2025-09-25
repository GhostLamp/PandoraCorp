extends Area2D
class_name CameraLock
@export var border:CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.currentRoom = get_parent()
		AudioGlobal.current_area = "pandoraCorp"
		
		if body.fuel < body.maxFuel:
			get_parent().startRoom()
			var camera = body.camera_2d
			var shape = border.shape.get_rect()
			camera.limit_top = border.global_position.y - shape.size.y/2 - 64
			camera.limit_bottom = border.global_position.y + shape.size.y/2 +64
			camera.limit_left = border.global_position.x - shape.size.x/2 -64
			camera.limit_right = border.global_position.x + shape.size.x/2  +64
		else:
			get_parent().overtime()
			var camera = body.camera_2d
			var shape = border.shape.get_rect()
			camera.limit_top = border.global_position.y - shape.size.y/2 - 64
			camera.limit_bottom = border.global_position.y + shape.size.y/2 +64
			camera.limit_left = border.global_position.x - shape.size.x/2 -64
			camera.limit_right = border.global_position.x + shape.size.x/2  +64


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		if body.fuel >= body.maxFuel:
			get_parent().end_room()
	
