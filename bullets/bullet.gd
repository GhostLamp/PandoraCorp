class_name Bullet
extends CharacterBody2D


@onready var kill_timer = $kill_timer
@onready var speed_stat = $speed

@export var status_manager: StatusManager
@export var text: Texture
@export var text_region: Rect2

@export var speed:float = 0
@export var damage:float = 0
@export var knockback:int = 0
@export var first_bounce:bool = true
@export var bounces:int = 0
@export var direction: Vector2 = Vector2(0,0)
@export var final_speed: float
@export var final_direction: Vector2
@export var pierce:int = 1
@export var enemies_hit:Array = []
@export var quick:bool = false
@export var style_modifiers:Array[String] = []




func wall_hit(colision_info):
	if bounces <=0:
		die()
	if first_bounce:
		first_bounce = false
		style_modifiers.append("trick_shot")
	bounces -= 1
	direction = direction.bounce(colision_info.get_normal())


func deal_damage(body:Node2D):
	var attack = Attack.new()
	attack.damage = damage
	attack.direction = direction
	attack.knockback = 5
	attack.quick = quick
	attack.style_modifiers = style_modifiers
	body.handle_hit(attack)
	
	place_effects(body)
	
	
	
	pierce -= 1
	if pierce <= 0:
		die()

func parry(gun_direction, parry_force):
	style_modifiers.append("redirect")
	direction = gun_direction
	speed_stat.speed += 400
	damage = damage * parry_force
	kill_timer.start()

func add_effect(effect):
	status_manager.new_effect(effect)

func die():
	queue_free()

func place_effects(body:Node2D):
	if !status_manager:
		return
	
	var effects = status_manager.status
	for effect in effects:
		if effect.has_method("on_hit"):
			effect.on_hit(body)
