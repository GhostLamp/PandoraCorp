extends Bullet

class_name Enemy_Bullet


@onready var sprite_2d_back: Sprite2D = $Sprite2DBack
@onready var sprite_2d_front: Sprite2D = $Sprite2DFront
@onready var area_2d: Area2D = $Area2D



var parried = false



func _ready():
	kill_timer.start()
	direction = Vector2.RIGHT.rotated(global_rotation)


func _process(delta):
	sprite_2d_back.rotation += delta*180
	sprite_2d_front.rotation += delta*180*1.5
	
	var colision_info = move_and_collide(direction)
	if colision_info:
		wall_hit(colision_info)
	
	velocity = direction * speed_stat.speed
	move_and_slide()

func _on_kill_timer_timeout():
	queue_free()




func parry(gun_direction, parry_force):
	direction = gun_direction 
	speed_stat.speed += 1000
	damage = damage * parry_force * 4
	kill_timer.start()
	area_2d.set_collision_mask_value(2,true)
	area_2d.set_collision_mask_value(7,false)
	area_2d.set_collision_layer_value(2,true)
	area_2d.set_collision_layer_value(7,false)
	parried = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		deal_damage(body)
	if body.has_method("handle_damage"):
		body.handle_damage(damage)
		pierce -=1
		var effects = status_manager.get_children()
		
		for effect in effects:
			if effect.has_method("handle_damage"):
				effect.handle_damage(body)
