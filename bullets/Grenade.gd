extends Projectile

class_name Bomb

@onready var sprite = $Sprite2D
@onready var spinner = $spinner
@onready var audio = $AudioStreamPlayer
@onready var body = $body

@export var explosion_damage = 5
@export var explosion : PackedScene
@export_range(0, 360) var arc:float = 0
@onready var static_body_2d: StaticBody2D = $StaticBody2D




func _ready():
	bounces = 30
	
	static_body_2d.rotation = (-global_rotation)
	direction = Vector2.RIGHT.rotated(global_rotation)
	body.velocity.y = -0.8 * gravity * 60 /2
	h = body.velocity.y*body.velocity.y/(2*gravity)
	
	speed = (((target.x - position.x)**2 + (target.y - position.y)**2)**0.5)*charge
	if target.x < position.x:
		sprite.flip_v = true
		spin *= -1
		drag *= -1
	


func _physics_process(delta):
	velocity = speed * direction
	var colision_info = move_and_collide(direction)
	if colision_info:
		if paried == true:
			if colision_info.get_collider() is Enemy:
				get_tree().current_scene.player.stylish("grenadePunch")
			die()
		else:
			wall_hit(colision_info)
			spinner.play("spinout")
	
	sprite.rotation += delta * spin
	spin -= drag * delta
	move_and_slide()
	airborn()

func airborn():
	sprite.position = body.position
	body.velocity.y += gravity
	if body.is_on_floor():
		die()

func die():
	var new_explosion = explosion.instantiate()
	new_explosion.position = global_position
	new_explosion.damage = explosion_damage
	get_tree().root.call_deferred("add_child", new_explosion)
	queue_free()



func _on_area_2d_body_entered(_body):
	if body.has_method("handle_hit"):
		if paried == true:
			die()
		else:
			deal_damage(_body)

func parry(gun_direction, parry_force):
	direction = gun_direction 
	set_collision_mask_value(2,true)
	body.velocity.y = 0
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
			body.velocity.y = -( -h + (gravity*(0.8*60)*(0.8*60))/2)/(0.8*60)
			speed += 1000
			direction = attack.direction
			
