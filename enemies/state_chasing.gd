extends State

func state_process(delta:float):
	
	parent.Target = (parent.next_path_position - parent.global_position).normalized()
	parent.velocity = parent.Target * parent.speed_stat.speed
	
	parent.ray_cast_2d.look_at(parent.player.colision.position)
	if parent.charge_level < 0:
		parent.charge_level += delta
	else:
		parent.ray_cast_2d.look_at(parent.player.colision.global_position)
		if parent.ray_cast_2d.is_colliding():
			if parent.ray_cast_2d.get_collider().is_queued_for_deletion():
				return
			if parent.ray_cast_2d.get_collider().has_method("handle_damage"):
				swapState("charging")
	
	parent.flipping()
