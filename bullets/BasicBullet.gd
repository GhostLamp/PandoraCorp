class_name BasicBullet
extends Bullet

@onready var kill_timer = $kill_timer
@onready var speed_stat = $speed
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
		queue_free()
	
	if final_direction:
		direction = direction.move_toward(final_direction,_delta*speed/1000)
	
	if pierce <= 0:
			queue_free()
	
	velocity = direction * speed
	move_and_slide()


func _on_kill_timer_timeout():
	queue_free()

func parry(gun_direction, parry_force):
	direction = gun_direction
	speed_stat.speed += 400
	damage = damage * parry_force
	kill_timer.start()
	collision_layer = 2
	collision_mask = 2






func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = damage
		attack.direction = direction
		attack.knockback = 5
		attack.quick = quick
		body.handle_hit(attack)
		
		var effects = status_manager.status
		for effect in effects:
			if effect.has_method("on_hit"):
				effect.on_hit(body)
	
		pierce -= 1
