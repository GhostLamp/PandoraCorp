extends State


func state_enter():
	parent.anim_tree["parameters/conditions/CHASING"] = true

func state_physics_process(delta:float):
	parent.pos.velocity.y += parent.gravity
	parent.Yvel += parent.gravity
	
	if parent.pos.position.y >= 1:
		parent.pos.velocity = Vector2(0,0)
		parent.pos.position = Vector2(0,0)
		parent.anim_tree["parameters/conditions/CHASING"] = false
		swapState("waiting")

func state_process(delta:float):
	parent.ray_cast_2d.look_at(parent.player.coli.position)
	if parent.charge_level < 0:
		parent.charge_level += delta*4
		
	else:
		parent.ray_cast_2d.look_at(parent.player.coli.global_position)
		if parent.ray_cast_2d.is_colliding():
			if parent.ray_cast_2d.get_collider().has_method("handle_damage"):
				
				parent.Target = (parent.player.coli.global_position - parent.global_position).normalized()
				parent.anim_tree["parameters/conditions/CHASING"] = false
				swapState("charging")
	parent.flipping()
