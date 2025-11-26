extends State

var tween:Tween

func state_enter():
	tween = get_tree().create_tween()
	player.gravity = 40
	player.coli.set_collision_layer_value(7,false)
	var spin_mult = sign(player.velocity.x) if player.velocity.x != 0 else 1
	
	tween.tween_property(player.anim_maneger,"rotation_degrees",360 * spin_mult,-player.coli.velocity.y /2000)

func state_process(delta:float):
	player.camera_2d.zoom = player.camera_2d.zoom.move_toward(Vector2(1.04,1.04),delta*5)
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
		


func swapState(newStateName:String):
	if tween:
		tween.kill
	
	player.anim_maneger.rotation_degrees = 0
	get_parent().set_state(newStateName)
