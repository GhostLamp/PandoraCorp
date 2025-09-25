extends CharacterBody2D

var  bounces = 6
var direction := Vector2.RIGHT

@onready var kill_timer = $kill_timer
@onready var speed_stat = $speed

@export var damage = 0
@onready var status_manager: Node2D = $status_manager2
@onready var animation_tree: AnimationTree = $AnimationTree



func _ready():
	kill_timer.start()



func _process(_delta):
	velocity = direction * speed_stat.speed
	var colision_info = move_and_collide(direction)
	if colision_info:
		direction = direction.bounce(colision_info.get_normal())
	
	move_and_slide()
	
		
func _on_kill_timer_timeout():
	animation_tree["parameters/conditions/dead"] = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
	
func handle_hit(attack: Attack):
	direction = attack.direction
	speed_stat.speed += 40 * attack.damage
	damage += attack.damage
	damage = clamp(damage,0 ,10)



func parry(gun_direction, parry_force):
	direction = gun_direction 
	speed_stat.speed += 400
	damage += parry_force
	kill_timer.start()






func _on_area_2d_area_entered(area):
	if area.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = damage
		attack.direction = direction
		area.handle_hit(attack)

func _on_area_2d_body_entered(body):
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = damage
		attack.direction = direction
		body.handle_hit(attack)
