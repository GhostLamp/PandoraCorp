extends Area2D
@onready var panel: Panel = $Panel

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("on_fire"):
		area.on_fire()
		panel.size -= Vector2(50,50)
		if panel.size.y <= 50:
			queue_free()
