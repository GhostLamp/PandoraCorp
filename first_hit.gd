extends Node2D

@export var status_type = 3

func on_hit(collider):
	if collider.has_node("health"):
		if collider.health_stat.max_health == collider.health_stat.health:
			var bullet:Bullet = get_parent().get_parent()
			bullet.damage *= 1.2
