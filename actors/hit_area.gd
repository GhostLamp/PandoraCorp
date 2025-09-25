extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Bullet:
		if area.get_parent().quick == true:
			var bullet:Bullet = area.get_parent()
			var attack = Attack.new()
			attack.damage = bullet.damage
			attack.direction = bullet.direction
			attack.knockback = 5
			attack.quick = bullet.quick
			get_parent().get_parent().handle_hit(attack)
			bullet.pierce -= 1
