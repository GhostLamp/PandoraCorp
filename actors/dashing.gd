extends State

func state_process(delta:float):
	player.dash_duration -= delta
	if (player.direction + player.base_direction):
		if player.dash_duration<= 0:
			player.velocity = player.velocity.move_toward(player.speed_stat.current_speed*(player.direction + player.base_direction), player.speed_stat.friction*delta)
			player.camera_2d.zoom = player.camera_2d.zoom.move_toward(Vector2(1.1,1.1),delta*10)
		else:
			player.velocity = player.speed_stat.current_speed*(player.direction + player.base_direction)
			player.camera_2d.zoom = player.camera_2d.zoom.move_toward(Vector2(1.1,1.1),delta*2)
	
	if player.dash_duration <= 0:
		swapState("grounded")
	
	
	player.check_tile(delta)
	player.create_after_image()
	
	if !player.coli.is_on_floor():
		player.set_collision_layer_value(8,false)
		player.set_collision_mask_value(8,false)
		swapState("airborn")
