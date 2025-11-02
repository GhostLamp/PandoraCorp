extends State


func state_process(delta:float):
	player.direction = Input.get_vector("left", "right", "up", "down")
	player.dash_duration = 0
	player.camera_2d.zoom = player.camera_2d.zoom.move_toward(Vector2(1,1),delta)
	if player.slam_counter > 0:
		player.slam_counter -= delta*10
	if (player.direction + player.base_direction):
		player.velocity = player.velocity.move_toward(player.speed_stat.current_speed*(player.direction + player.base_direction), (player.speed_stat.accel)*delta )
		player.adrenaline_stat.adrenaline += delta*5
	
	else:
		player.velocity = player.velocity.move_toward(Vector2(0,0), player.speed_stat.friction*delta)
	
	player.check_tile(delta)
	
	
	if Input.is_action_just_pressed("ui_accept") and player.adrenaline_stat.adrenaline >= 10:
		player.dash_duration = 0.3
		player.adrenaline_stat.adrenaline -= 10
		player.invulnerability(0.1)
		player.speed_stat.current_speed = player.speed_stat.speed*2.5
		swapState("dashing")
		
		player.tevii_tree["parameters/conditions/dash"] = true
		player.tevii_tree["parameters/conditions/Look_front"] = false
		player.tevii_tree["parameters/conditions/Look_back"] = false
		await get_tree().create_timer(delta).timeout
		player.tevii_tree["parameters/conditions/dash"] = false
	
	if !player.coli.is_on_floor():
		player.set_collision_layer_value(8,false)
		player.set_collision_mask_value(8,false)
		swapState("airborn")
	
	player.flipping(delta, player.get_global_mouse_position() - player.global_position)
