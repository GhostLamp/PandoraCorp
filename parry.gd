extends Area2D

signal parry_hit



func _on_area_entered(area: Area2D) -> void:
	if area.has_method("parry"):
		var bullet_direction = get_parent().bullet_direction
		area.parry(bullet_direction.normalized(), get_parent().parry_force)
		emit_signal("parry_hit")
		HitstopEfect.hitstop_efect_short()
		HitstopManeger.hitstop_short()
