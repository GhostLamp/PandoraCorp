extends State
var wait_time:float = 0.1875

func state_enter():
	parent.anim_tree["parameters/conditions/hop"] = true
	wait_time = 0.1875

func state_process(delta):
	
	if wait_time >= 0:
		wait_time -= delta
		return
	
	parent.Target = (parent.next_path_position - parent.global_position).normalized()
	parent.velocity = (parent.Target + parent.base_direction) * parent.speed_stat.speed
	
	parent.jump(-2000)
	parent.anim_tree["parameters/conditions/hop"] = false
	swapState("chasing")
