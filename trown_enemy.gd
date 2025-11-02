extends BasicBullet
class_name TrownEnemy

var enemy:Enemy

func _ready():
	enemy.set_collision_layer_value(2,false)
	kill_timer.start()
	direction = Vector2.RIGHT.rotated(global_rotation)
	if text:
		sprite.texture = text
		if text_region: 
			sprite.region_enabled = true
			sprite.region_rect = text_region
		
		sprite.scale = Vector2(1,1)

func _process(_delta):
	if !is_instance_valid(enemy):
		queue_free()
	var colision_info = move_and_collide(direction)
	if colision_info:
		die()
	
	if final_direction:
		direction = direction.move_toward(final_direction,_delta*speed/1000)
	
	if pierce <= 0:
			die()
	
	enemy.global_position = global_position
	
	velocity = direction * speed
	move_and_slide()


func die():
	enemy.held = false
	enemy.set_collision_layer_value(2,true)
	enemy.set_process(true)
	knockback *= -1
	
	damage = damage/2 + 0.5
	deal_damage(enemy)
	enemy.rotation = 0
	queue_free()

func deal_damage(body:Node2D):
	var attack = Attack.new()
	attack.damage = damage
	attack.direction = direction
	attack.knockback = 5
	attack.quick = quick
	attack.style_modifiers = style_modifiers
	body.handle_hit(attack)
	
	place_effects(body)
