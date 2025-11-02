class_name BasicBullet
extends Bullet


@onready var sprite: Sprite2D = $Sprite2D



func _ready():
	kill_timer.start()
	direction = Vector2.RIGHT.rotated(global_rotation)
	if text:
		sprite.texture = text
		if text_region: 
			sprite.region_enabled = true
			sprite.region_rect = text_region
		
		sprite.scale = Vector2(1,1)


func _process(_delta):
	var colision_info = move_and_collide(direction)
	if colision_info:
		wall_hit(colision_info)
	
	if final_direction:
		direction = direction.move_toward(final_direction,_delta*speed/1000)
	
	
	velocity = direction * speed
	move_and_slide()


func _on_kill_timer_timeout():
	die()







func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		deal_damage(body)
