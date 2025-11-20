extends Projectile

@onready var area_2d: Area2D = $body/Area2D
@onready var parry_area: Area2D = $parry_area


func _ready():
	gravity*=2
	direction = Vector2.RIGHT.rotated(global_rotation)
	coli.velocity.y = -gravity * 60/2
	
	speed = global_position.distance_to(target-direction)
	if target.x < position.x:
		sprite.flip_v = true
		spin *= -1
		drag *= -1

func _process(delta):
	velocity = speed * direction
	var colision_info = move_and_collide(direction)
	if colision_info:
		die()
	move_and_collide(-direction)
	move_and_slide()
	sprite.rotation += delta * spin/2
	spin -= drag * delta
	if coli.position.y > -164 and coli.velocity.y > 0:
		area_2d.monitoring = true
		parry_area.monitorable = true



func _on_area_entered(area: Area2D) -> void:
	pass



func _on_area_2d_body_entered(body):
	if body.has_method("handle_hit"):
		deal_damage(body)
		die()
	if body.has_method("handle_damage"):
		body.handle_damage(damage)
		pierce -=1
		var effects = status_manager.get_children()
		
		for effect in effects:
			if effect.has_method("handle_damage"):
				effect.handle_damage(body)

func parry(gun_direction, parry_force):
	direction = gun_direction 
	coli.velocity.y = 0
	speed += 5000
	area_2d.set_collision_mask_value(2,true)
	area_2d.set_collision_mask_value(7,false)
	area_2d.set_collision_layer_value(2,true)
	area_2d.set_collision_layer_value(7,false)
	gravity= 0
	paried = true
	
