extends State

var inputs:int = 0

func state_enter():
	inputs = 0
	player.velocity = Vector2(0,0)
	player.direction = Vector2(0,0)
	player.visible = false

func state_process(delta:float):
	player.collision.disabled = true
	player.check_tile(delta)
	if (player.base_direction):
		player.velocity = player.velocity.move_toward(800*(player.base_direction), (800)*delta )
	else:
		player.velocity = player.velocity.move_toward(Vector2(0,0), player.speed_stat.friction*delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		inputs+=1
	
	if inputs >= 6:
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
	

func swapState(newStateName:String):
	player.collision.disabled = false
	player.visible = true
	get_parent().set_state(newStateName)
