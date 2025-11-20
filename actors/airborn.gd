extends State

func state_enter():
	player.gravity = 40
	player.coli.set_collision_layer_value(7,false)

func state_process(delta:float):
	player.direction = Input.get_vector("left", "right", "up", "down")
	
	
	
	if player.direction.x != 0:
		player.velocity.x = lerp(player.velocity.x, player.direction.x * player.speed_stat.current_speed , 0.02)
	if player.direction.y != 0:
		player.velocity.y = lerp(player.velocity.y, player.direction.y * player.speed_stat.current_speed , 0.02)
	
	player.flipping(delta, player.get_global_mouse_position() - player.global_position )
	
	if player.coli.is_on_floor():
		player.check_tile(delta)
		swapState("grounded")
		player.coli.set_collision_layer_value(7,true)
	
	
	if Input.is_action_just_pressed("ui_accept"):
		player.coli.velocity.y += -2000
		player.gravity = 200
		player.slam_counter += 1
		
		swapState("slamming")
		
