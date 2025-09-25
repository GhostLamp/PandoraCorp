extends CharacterBody2D

class_name Enemy_Bullet


@onready var kill_timer = $kill_timer
@onready var speed_stat = $speed
@onready var status_manager = $status_manager
@onready var sprite_2d_back: Sprite2D = $Sprite2DBack
@onready var sprite_2d_front: Sprite2D = $Sprite2DFront

@export var damage = 0
var direction := Vector2.RIGHT
var parried = false



func _ready():
	kill_timer.start()
	direction = Vector2.RIGHT.rotated(global_rotation)


func _process(delta):
	sprite_2d_back.rotation += delta*180
	sprite_2d_front.rotation += delta*180*1.5
	var colision_info = move_and_collide(direction)
	if colision_info:
		if parried == false:
			if colision_info.get_collider().has_method("handle_damage"):
				var collider = colision_info.get_collider()
				collider.handle_damage()
				global_position = colision_info.get_position()
				
				var effects = status_manager.get_children()
				
				for effect in effects:
					if effect.has_method("handle_damage"):
						effect.handle_damage(collider)
		else:
			if colision_info.get_collider().has_method("handle_hit"):
				var collider = colision_info.get_collider()
				var attack = Attack.new()
				attack.damage = damage
				attack.direction = direction
				collider.handle_hit(attack)
				global_position = colision_info.get_position()
				
				var effects = status_manager.get_children()
				
				for effect in effects:
					if effect.has_method("handle_hit"):
						effect.handle_hit(collider)
				
		queue_free()
	velocity = direction * speed_stat.speed
	move_and_slide()

func _on_kill_timer_timeout():
	queue_free()

func parry(gun_direction, parry_force):
	direction = gun_direction 
	speed_stat.speed += 1000
	damage = damage * parry_force * 4
	kill_timer.start()
	collision_layer = 2
	collision_mask = 2
	parried = true
