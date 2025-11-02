extends State

func state_process(delta:float):
	player.direction = Input.get_vector("left", "right", "up", "down")
	player.gravity = 40
	
	
	
	if player.direction.x != 0:
		player.velocity.x = lerp(player.velocity.x, player.direction.x * player.speed_stat.current_speed , 0.02)
	if player.direction.y != 0:
		player.velocity.y = lerp(player.velocity.y, player.direction.y * player.speed_stat.current_speed , 0.02)
	
	player.flipping(delta, player.get_global_mouse_position() - player.global_position )
	
	if player.coli.is_on_floor():
		player.check_tile(delta)
		swapState("grounded")
	
	
	if Input.is_action_just_pressed("ui_accept"):
		player.coli.velocity.y += -2000
		player.gravity = 200
		player.slam_counter += 1
		
		player.tevii_tree["parameters/conditions/slam"] = true
		player.tevii_tree["parameters/conditions/Look_front"] = false
		player.tevii_tree["parameters/conditions/Look_back"] = false
		await get_tree().create_timer(delta).timeout
		player.tevii_tree["parameters/conditions/slam"] = false
		
		swapState("slamming")
		
