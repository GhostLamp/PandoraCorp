extends State

func state_process(delta:float):
	parent.velocity =Vector2(0,0)
	parent.barrel_origin.scale += Vector2(1,1)*delta
	parent.nuzzel_holder.look_at(parent.player.coli.global_position)
	parent.Target = (parent.player.coli.global_position - parent.position).normalized()
	parent.charge_level += delta*2
	if parent.charge_level >= 2:
		swapState("attacking")
	
	parent.flipping()
