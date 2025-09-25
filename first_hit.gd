extends Node2D

@export var status_type = 3

func on_hit(collider):
	if collider.has_node("health"):
		if collider.health_stat.max_health == collider.health_stat.health:
			var new_attack = Attack.new()
			new_attack.damage = 1
			collider.handle_hit(new_attack)
