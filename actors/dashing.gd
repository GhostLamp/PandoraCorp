extends State



func state_enter():
	player.dash_hammer.visible = true
	player.dash_area.monitoring = true
	player.can_dash = false

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
		player.dash_hammer.visible = false
		swapState("grounded")
	
	if Input.is_action_just_pressed("ui_accept") and player.adrenaline_stat.adrenaline >= 10 and player.can_dash:
		player.direction = Input.get_vector("left", "right", "up", "down")
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
	
	player.check_tile(delta)
	player.create_after_image()
	
	if !player.coli.is_on_floor():
		player.set_collision_layer_value(8,false)
		player.set_collision_mask_value(8,false)
		player.dash_hammer.visible = false
		swapState("airborn")

func swapState(newStateName:String):
	player.dash_area.monitoring = false
	get_parent().set_state(newStateName)
