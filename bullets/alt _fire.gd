extends CharacterBody2D

class_name Alt_fire

var  bounces = 6
var direction := Vector2.RIGHT

@onready var kill_timer = $kill_timer
@onready var speed_stat = $speed

@export var damage = 0


func _ready():
	kill_timer.start()
	direction = Vector2.RIGHT.rotated(global_rotation)



func _process(_delta):
	move_and_slide()
	var colision_info = move_and_collide(direction)
	if colision_info:
		direction = direction.bounce(colision_info.get_normal())
	velocity = direction * speed_stat.speed
		
func _on_kill_timer_timeout():
	queue_free()
	
	


func _on_area_2d_body_entered(body):
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = damage
		attack.direction = direction
		body.handle_hit(attack)
		

func parry(gun_direction, parry_force):
	direction = gun_direction 
	speed_stat.speed += 400
	damage = damage*parry_force
	kill_timer.start()




func _on_area_2d_area_entered(area):
	if area.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = damage
		attack.direction = direction
		attack.soft = false
		area.handle_hit(attack)
