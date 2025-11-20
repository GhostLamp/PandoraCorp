extends BaseActiveStrat

@export var special_cooldown: Timer 
@export var barrel_origin:Marker2D
@export var star:PackedScene

func  special_activation():
	special_cooldown.start()
	
	var mouse = get_global_mouse_position() 
	var new_star = star.instantiate()
	new_star.position = barrel_origin.global_position if barrel_origin else global_position
	new_star.target = mouse
	new_star.look_at(mouse)
	get_tree().root.call_deferred("add_child", new_star)
