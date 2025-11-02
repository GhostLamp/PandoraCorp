extends Bullet
class_name  TargetedRay

@onready var sprite: Sprite2D = $Sprite2D

var target_enemy:Enemy
var time = 0
var delay:int = 0

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
	delay += _delta
	if delay <0:
		return
	
	
	
	if final_direction:
		direction = direction.move_toward(final_direction,_delta*speed)
	
	if pierce <= 0:
			queue_free()
	
	velocity = direction * speed
	move_and_slide()


func _on_kill_timer_timeout():
	time +=1
	if time == 1:
		rotation_degrees += 80
	if time == 2:
		rotation_degrees -= 160
		kill_timer.wait_time = 0.2
	if time == 3:
		if !is_instance_valid(target_enemy):
			queue_free()
			return
		look_at(target_enemy.global_position)
		kill_timer.wait_time = 0.2
		speed = position.distance_to(target_enemy.global_position)/0.2
	if time == 4:
		var new_attack:Attack = Attack.new()
		new_attack.damage = 1
		if !is_instance_valid(target_enemy):
			queue_free()
			return
		target_enemy.handle_hit(new_attack)
		
		queue_free()
	direction = Vector2.RIGHT.rotated(global_rotation)
