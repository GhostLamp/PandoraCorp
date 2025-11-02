extends State

func state_process(_delta:float):
	var crusher = parent.player.currentRoom.minigame.crusher.crusher
	parent.Target = (crusher.global_position-parent.next_path_position).normalized()
	parent.velocity = parent.Target * -parent.speed_stat.speed
	
	
	parent.flipping()
