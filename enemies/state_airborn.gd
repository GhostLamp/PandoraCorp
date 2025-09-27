extends State

func state_process(_delta:float):
	parent.body.velocity.y += parent.gravity
	parent.Yvel += parent.gravity 
	
	if parent.Yvel <= 0:
		parent.pos.velocity = Vector2(0,0)
		parent.pos.position = Vector2(0,0)
		swapState("chasing")
