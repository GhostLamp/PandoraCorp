extends Area2D

@export var filter_quick:bool = true
@export var damage_reciver:Node2D
@export var total_hits:int = 1

func _on_area_entered(area: Area2D) -> void:
	if total_hits <= 0:
		return
	
	if area.get_parent() is Bullet:
		total_hits -= 1
		var bullet:Bullet = area.get_parent()
		if bullet.quick == true or !filter_quick:
			bullet.deal_damage(damage_reciver)
