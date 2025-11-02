extends BaseActiveStrat

@export var yoyo : PackedScene
@export var barrel_origin: Marker2D 
@export var special_cooldown: Timer 

var yoyo_out:Array = []

func get_adrenaline_cost():
	if yoyo_out.size() > 0:
		return 0
	return adrenaline_cost

func  special_activation():
	special_cooldown.start()
	var player:Player = get_parent().get_parent().get_parent()
	
	if yoyo_out.size() > 0:
		if is_instance_valid(yoyo_out[0]):
			pass
		else:
			yoyo_out.clear()

	
	if yoyo_out.size() <= 0:
		var mouse = get_global_mouse_position()
		var new_yoyo:Projectile = yoyo.instantiate()
		new_yoyo.position = barrel_origin.global_position if barrel_origin else global_position
		new_yoyo.damage = 10
		new_yoyo.direction = mouse.normalized()
		new_yoyo.target = mouse
		new_yoyo.dono.append(player)
		yoyo_out.append(new_yoyo)
		new_yoyo.rotation = barrel_origin.global_rotation
		get_tree().current_scene.call_deferred("add_child", new_yoyo)
		
	elif yoyo_out[0].pulling == true:
		yoyo_out[0].queue_free()
		yoyo_out.clear()


func finish():
	if yoyo_out.size() > 0:
		if is_instance_valid(yoyo_out[0]):
			yoyo_out[0].queue_free()
			yoyo_out.clear()
		else:
			yoyo_out.clear()
