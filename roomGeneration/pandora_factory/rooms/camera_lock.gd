extends Area2D
class_name CameraLock
@export var border:CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player: 
		lock_camera(body)
		if get_tree().current_scene.player.currentRoom != get_parent():
			if body.currentRoom:
				body.currentRoom.end_room()
				body.currentRoom.end_navigation()
			
			if body.rooms_to_explore.has(get_parent()):
				body.rooms_to_explore.erase(get_parent())
			
			body.currentRoom = get_parent()
			get_parent().fade_in()
			get_parent().setNavigation()
			
			
			for i in get_overlapping_bodies():
				if i is Box:
					i.check_tile()
			
			AudioGlobal.current_area = "pandoraCorp"
			body.set_safe_position(100)
			if body.fuel < body.maxFuel:
				get_parent().startRoom()
				
			else:
				get_parent().overtime()
			
			return

func lock_camera(player:Player):
	var camera = player.camera_2d
	var shape = border.shape.get_rect()
	camera.limit_top = border.global_position.y - shape.size.y/2 - 52
	camera.limit_bottom = border.global_position.y + shape.size.y/2 +52
	camera.limit_left = border.global_position.x - shape.size.x/2 -52
	camera.limit_right = border.global_position.x + shape.size.x/2  +52
