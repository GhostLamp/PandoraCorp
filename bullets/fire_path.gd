extends Area2D
	
func _on_area_entered(area: Area2D) -> void:
	if area.has_method("on_fire"):
		area.on_fire()
		
