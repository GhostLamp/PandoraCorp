extends State

func state_physics_process(delta:float):
	parent.pos.velocity.y += parent.gravity
	parent.Yvel += parent.gravity
	
	if parent.pos.position.y >= 0:
		parent.pos.velocity = Vector2(0,0)
		parent.pos.position = Vector2(0,0)
		swapState("chasing")
