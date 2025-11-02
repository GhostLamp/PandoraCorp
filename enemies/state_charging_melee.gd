extends State

func state_process(delta:float):
	parent.velocity =+ parent.Target * parent.speed_stat.speed / -5
	parent.speed_stat.current_speed = parent.speed_stat.speed * 3
	parent.charge_level += delta*2
	if parent.charge_level >= 1:
		swapState("attacking")
	
	parent.flipping()
