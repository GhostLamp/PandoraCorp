extends Node2D

@export var explosion_damage = 5
@export var explosion : PackedScene

func handle_hit(attack:Attack):
	if attack.quick == true:
		HitstopEfect.hitstop_efect_short()
		HitstopManeger.hitstop_short()
		var new_explosion = explosion.instantiate()
		new_explosion.position = global_position
		new_explosion.damage = explosion_damage
		get_tree().root.call_deferred("add_child", new_explosion)
		get_parent().style.emit("blocked")
