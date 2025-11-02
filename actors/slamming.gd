extends State

@export var shock_wave:PackedScene

func state_process(delta:float):
	player.camera_2d.zoom = player.camera_2d.zoom.move_toward(Vector2(1.1,1.1),delta*5)
	player.tevii_tree["parameters/conditions/Look_front"] = false
	player.tevii_tree["parameters/conditions/Look_back"] = false
	
	if player.coli.is_on_floor():
		if player.check_tile(delta) == "unsafe":
			player.velocity = Vector2(0,0)
			player.direction = Vector2(0,0)
			player.speed_stat.current_speed = 0
			player.damaged(10)
			player.respawn()
			swapState("grounded")
		
		slam_end()
	
	player.create_after_image()


func slam_end():
	var new_shock_wave = shock_wave.instantiate()
	new_shock_wave.position = player.global_position + Vector2(0,40)
	new_shock_wave.damage = 1
	get_tree().root.call_deferred("add_child", new_shock_wave)
	swapState("grounded")
