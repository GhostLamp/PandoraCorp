extends Area2D
@onready var label: Label = $Label

var first_time:bool = true


func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		if first_time:
			HitstopEfect.show_level(" pandora ", " corp. ", " level - 0 ")
			first_time = false
			if body is Player and get_tree().current_scene.player.currentRoom != get_parent().get_parent():
				if body.currentRoom:
					body.currentRoom.end_room()
					body.currentRoom.end_navigation()
				
				
				AudioGlobal.current_area = "pandoraCorp"
				body.currentRoom = get_parent().get_parent()
				get_parent().get_parent().fade_in()
				get_parent().get_parent().setNavigation()
				get_parent().get_parent().startRoom()
		
		
		
		if body.fuel >= body.maxFuel:
			HitstopEfect.swap_to_level_in()
			await get_tree().create_timer(0.5).timeout
			body.end_level()
