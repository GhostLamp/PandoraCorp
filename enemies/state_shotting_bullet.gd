extends State

func state_process(_delta):
	parent.Target = (parent.player.position - parent.position).normalized()
	parent.anim_tree["parameters/conditions/attacking"] = true
	await get_tree().create_timer(_delta).timeout
	parent.anim_tree["parameters/conditions/attacking"] = false
	for i in parent.bullet_count:
		var new_bullet = parent.bullet.instantiate()
		new_bullet.position = parent.barrel_origin.global_position if parent.barrel_origin else parent.global_position
		new_bullet.damage = 1
		if parent.bullet_count == 1:
			new_bullet.rotation = parent.barrel_origin.global_rotation
		else:
			var arc_rad = deg_to_rad(parent.arc)
			var increment = arc_rad / (parent.bullet_count - 1)
			new_bullet.global_rotation = ( parent.barrel_origin.global_rotation + increment * i - arc_rad / 2)
		get_tree().root.call_deferred("add_child", new_bullet)
	
	
	parent.flipping()
	swapState("chasing")

func swapState(newStateName:String):
	parent.charge_level = -1.5
	parent.barrel_origin.scale = Vector2(0.01,0.01)
	parent.anim_tree["parameters/conditions/CHASING"] = true
	parent.anim_tree["parameters/conditions/CHARGING"] = false
	
	get_parent().set_state(newStateName)
