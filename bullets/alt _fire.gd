extends Bullet

class_name Alt_fire





func _ready():
	kill_timer.start()
	bounces = 6
	direction = Vector2.RIGHT.rotated(global_rotation)



func _process(_delta):
	move_and_slide()
	var colision_info = move_and_collide(direction)
	if colision_info:
		wall_hit(colision_info)
	velocity = direction * speed_stat.speed
		
func _on_kill_timer_timeout():
	queue_free()
	
	


func _on_area_2d_body_entered(body):
	if body.has_method("handle_hit"):
		deal_damage(body)
		





func _on_area_2d_area_entered(area):
	if area.has_method("handle_hit"):
		deal_damage(area)
