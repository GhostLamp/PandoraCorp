extends State



func state_process(delta:float):
	parent.velocity = (parent.Target + parent.base_direction) * parent.speed_stat.current_speed
	parent.parry_area.disabled = false
	var colision_info = parent.move_and_collide(parent.Target + parent.base_direction)
	parent.create_after_image()
	
	if colision_info:
		var tween = get_tree().create_tween()
		parent.Target = (parent.Target + parent.base_direction).bounce(colision_info.get_normal())
		parent.parry_area.disabled = true
		parent.charge_level = 1.2
		tween.tween_property(parent.speed_stat,"current_speed",0,1)
		
		parent.anim_tree["parameters/conditions/Bonk"] = true
		parent.anim_tree["parameters/conditions/is_agro"] = false
		await get_tree().create_timer(delta).timeout
		parent.anim_tree["parameters/conditions/Bonk"] = false
		
		swapState("stunned")
	
	
	parent.charge_level -= delta*2
	if parent.charge_level <= 0:
		attackEnd()

func attackEnd():
	var tween = get_tree().create_tween()
	tween.tween_property(parent,"velocity",Vector2(0,0),1)
	parent.charge_level = -0.5
	parent.parry_area.disabled = true
	parent.anim_tree["parameters/conditions/Default"] = true
	parent.anim_tree["parameters/conditions/is_agro"] = false
	swapState("chasing")
