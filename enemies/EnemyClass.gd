extends CharacterBody2D
class_name Enemy

signal style

@onready var hit_anim: AnimationPlayer = $body/anim_maneger/hit_anim
@onready var health_stat = $health
@onready var knock_down:Timer = $knock_down
@onready var speed_stat = $speed




@export var cost:float = 1
@export var charge_level:float = 0
@export var flip_scale = Vector2(1,0)
var Target
@export var knockbackmult:float = 100
var Left:bool = true
var Yvel:float = 0
@export var gravity:float = 40
var agro:bool = false
var is_attacking:bool = false
var momentun:float = 0
var stunned = false
var next_path_position 
var player:Player 
var alive:bool = true

var spawned = false

func _ready() -> void:
	get_parent().spawn(self)
	player = get_tree().current_scene.player
	next_path_position = position


func handle_hit(attack: Attack):
	hit_anim.play("hit")
	if health_stat.health > 0:
		if health_stat.health == health_stat.max_health:
			is_one_shot(attack)
		
		health_stat.health -= attack.damage
		if attack.direction != Vector2(0,0):
			knock_down.start()
			velocity = attack.direction.normalized() * knockbackmult * attack.knockback
		style.emit("enemy_hit")
		
		if alive:
			if health_stat.health <= 0:
				alive = false
				collision_layer = 32
				speed_stat.speed = 0
				style.emit("enemy_killed")
				await get_tree().create_timer(0.1).timeout
				get_parent().kill_enemy(self)

func spawning(delta):
	knock_down.start()

func is_one_shot(attack: Attack):
	if attack.damage >= health_stat.health:
		collision_layer = 32
		speed_stat.speed = 0
		style.emit("one_shot")
