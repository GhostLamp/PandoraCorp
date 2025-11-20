extends State

var wait_time:float = 0.5

func state_enter():
	wait_time = 0.5
	parent.anim_tree["parameters/conditions/on_ground"] = true

func state_process(delta:float):
	
	parent.flipping()
	parent.velocity = Vector2(0,0)
	parent.ray_cast_2d.look_at(parent.player.coli.position)
	parent.charge_level = 0
	
	if wait_time >= 0:
		wait_time -= delta
		return
	
	
	
	
	parent.anim_tree["parameters/conditions/on_ground"] = false
	swapState("hop")
