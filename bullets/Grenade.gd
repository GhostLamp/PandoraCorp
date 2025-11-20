extends Projectile

class_name Bomb


@onready var audio = $AudioStreamPlayer

@export var explosion_damage = 5
@export var explosion : PackedScene
@export_range(0, 360) var arc:float = 0





func _ready():
	bounces = 30
	
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	coli.velocity.y = - gravity * 60 /2
	

	
	speed = (position.distance_to(target))*charge
	if target.x < position.x:
		sprite.flip_v = true
		spin *= -1
		drag *= -1
	


func _process(delta):
	velocity = speed * direction
	
	var colision_info = move_and_collide(direction)
	if colision_info:
		if paried == true:
			if colision_info.get_collider() is Enemy:
				get_tree().current_scene.player.stylish("grenadePunch")
			die()
		else:
			wall_hit(colision_info)
	move_and_collide(-direction)
	sprite.rotation += delta * spin
	spin -= drag * delta
	move_and_slide()



func die():
	var new_explosion = explosion.instantiate()
	new_explosion.position = global_position
	new_explosion.damage = explosion_damage
	get_tree().root.call_deferred("add_child", new_explosion)
	queue_free()



func _on_area_2d_body_entered(body):
	if body.has_method("handle_hit"):
		if paried == true:
			die()
		else:
			deal_damage(body)

func parry(gun_direction, parry_force):
	direction = gun_direction 
	set_collision_mask_value(2,true)
	coli.velocity.y = 0
	speed += 5000
	explosion_damage += parry_force
	gravity= 0
	kill_timer.start()
	paried = true
	
func handle_hit(attack: Attack):
	if paried == false:
		if attack.soft == false:
			HitstopEfect.hitstop_efect_short()
			HitstopManeger.hitstop_short()
			var new_explosion:Explosion = explosion.instantiate()
			new_explosion.damage += explosion_damage + attack.damage
			new_explosion.scale = Vector2(1,1)*1.5
			new_explosion.position = global_position
			get_tree().root.call_deferred("add_child", new_explosion)
			audio.play()
			queue_free()
		else:
			speed += 1000
			direction = attack.direction
			
