extends State


func state_process(delta:float):
	parent.charge_level -= delta
	parent.velocity = parent.Target * parent.momentun / 5
	if parent.charge_level <= 0:
		parent.stunned = false
		swapState("chasing")

func swapState(newStateName:String):
	var tween = get_tree().create_tween()
	tween.tween_property(parent,"velocity",Vector2(0,0),1)
	
	parent.charge_level = -0.5
	parent.parry_area.disabled = true
	parent.anim_tree["parameters/conditions/Default"] = true
	parent.anim_tree["parameters/conditions/is_agro"] = false
	
	get_parent().set_state(newStateName)
