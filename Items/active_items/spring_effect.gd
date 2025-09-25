extends BaseActiveStrat

@export var special_cooldown: Timer 

func  special_activation():
	get_parent().get_parent().get_parent().jump(-3000)
	special_cooldown.start()
