extends State

func state_enter():
	parent.anim_tree["parameters/conditions/CHARGING"] = true

func state_physics_process(delta:float):
	parent.pos.velocity.y += parent.gravity
	parent.Yvel += parent.gravity
	
	if parent.pos.position.y >= 0:
		parent.pos.velocity = Vector2(0,0)
		parent.pos.position = Vector2(0,0)
		parent.anim_tree["parameters/conditions/CHASING"] = false
		swapState("waiting")

func state_process(delta:float):
	parent.Target = (parent.player.coli.global_position - parent.position).normalized()
	parent.charge_level += delta*2
	parent.nuzzel_holder.look_at(parent.player.coli.global_position)
	
	
	if parent.charge_level >= 0.125:
		parent.anim_tree["parameters/conditions/CHARGING"] = false
		swapState("attacking")
	
	
	parent.flipping()
