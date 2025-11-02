extends State

var shadow_value:float = 0

func state_enter():
	shadow_value = 0

func state_process(delta:float):
	if player.check_tile(delta) != "unsafe":
		swapState("grounded")
		return
	
	player.velocity = player.velocity.move_toward(Vector2(0,0),player.speed_stat.friction/100)
	shadow_value += delta*4
	player.sprite.material.set_shader_parameter("shadowing", 1)
	player.sprite.material.set_shader_parameter("alpha", shadow_value)
	
	player.anim_maneger.rotation_degrees = 90 * shadow_value * roundf(player.direction.x+ (1-abs(player.direction.x)))
	player.anim_maneger.position.y = 64 * shadow_value
	
	if Input.is_action_just_pressed("ui_accept") and player.adrenaline_stat.adrenaline >= 10:
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
	
	if !player.coli.is_on_floor():
		player.set_collision_layer_value(8,false)
		player.set_collision_mask_value(8,false)
		swapState("airborn")
	
	if shadow_value >= 1:
		player.velocity = Vector2(0,0)
		player.direction = Vector2(0,0)
		player.speed_stat.current_speed = 0
		player.coli.position.y = -1680
		player.damaged(10)
		player.respawn()
		swapState("airborn")


func swapState(newStateName:String):
	player.anim_maneger.rotation_degrees = 0
	player.anim_maneger.position.y = 0
	player.sprite.material.set_shader_parameter("alpha", 0)
	player.sprite.material.set_shader_parameter("shadowing", 0)
	get_parent().set_state(newStateName)
