extends CharacterBody2D

signal enemy_hit
@export var ghost : PackedScene
@export var Explosion : PackedScene

@export var bullet_count : int
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D

@onready var health_stat = $health
@onready var speed_stat = $speed
@onready var player = get_parent().get_parent().get_node("player")
@onready var anim = $enemy_body/AnimatedSprite2D
@onready var knock_down = $knock_down
@onready var fliper = $fliper
@onready var anim_tree = $AnimationTree
@onready var collision = $CollisionShape2D2
@onready var enemy_body = $enemy_body
@onready var status_maneger = $status_manager
@onready var charge_timer = $charge_timer
@onready var ghost_timer = $ghost_timer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@onready var trail: Line2D = $enemy_body/Node2D/trail
@onready var trail_2: Line2D = $enemy_body/Node2D2/trail2
@onready var parry_area: Area2D = $parry_area




var Target
var knockback_direction
var knockback = 100
var Left = false
var Yvel = 0
var gravity = 40
var agro = false
var momentun = 0
var stunned = false
var charge = 0
var next_path_position 
var paried = false

enum state {CHASING, ATTACKING, AIRBORN, STUNNED}
var enemy_state = state.CHASING

func _ready() -> void:
	get_parent().spawn(self)
	next_path_position = position


func _process(delta):
	if enemy_state == state.CHASING:
		chasing()
	elif enemy_state == state.ATTACKING:
		attacking(delta)
	elif enemy_state == state.AIRBORN:
		airborn()
	elif enemy_state == state.STUNNED:
		Stunned()
	
	move_and_slide()
	parry_area.position = enemy_body.position

func _physics_process(_delta):
	
	if Yvel < 0:
		enemy_state = state.AIRBORN
	else:
		if stunned == true:
			enemy_state = state.STUNNED
		else:
			if agro == true:
				enemy_state = state.ATTACKING
			else:
				enemy_state = state.CHASING
		
	

func airborn():
	agro = false
	enemy_body.velocity.y += gravity
	Yvel += gravity 
	

func chasing():
	Target = (next_path_position - position).normalized()
	if knock_down.is_stopped() and Yvel >= 0:
		velocity = Target * speed_stat.speed
	flipping()
	
	enemy_body.velocity = Vector2(0,0)
	enemy_body.position = Vector2(0,-68)
	
	ray_cast_2d.look_at(player.position)
	if ray_cast_2d.is_colliding():
		if ray_cast_2d.get_collider().has_method("handle_damage"):
			charge_timer.start()
			agro = true
			charge = 0
			momentun = 0
			enemy_body.velocity.y -= 1200
			
			anim_tree["parameters/conditions/is_agro"] = true
			await get_tree().create_timer(0.1875).timeout
			anim_tree["parameters/conditions/is_agro"] = false


func attacking(_delta):
	velocity = Target * momentun
	
	trail.visible = true
	trail_2.visible = true
	
	if paried == false:
		enemy_body.velocity.y += gravity
	else:
		var colision_info = move_and_collide(Target)
		if colision_info:
			_on_charge_timer_timeout()
	
	flipping()

func Stunned():
	if knock_down.is_stopped() and Yvel >= 0:
			velocity = Target * momentun / 5
	await get_tree().create_timer(1.2).timeout
	if stunned != false:
		stunned = false
		charge = 0
		agro = false
	

func jump(vel):
	if enemy_state != state.AIRBORN:
		Yvel = vel
		enemy_body.velocity.y = vel/2


func handle_hit(damage, damage_direction):
	health_stat.health -= damage
	if damage_direction != Vector2(0,0):
		knock_down.start()
		velocity = damage_direction.normalized() * knockback * damage
	print(health_stat.health, "enemy hit")
	
	emit_signal("enemy_hit")
	
	if health_stat.health <= 0:
		speed_stat.speed = 0
		collision_layer = 32
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
		
		
func flipping():
	var mouse = next_path_position - position
	if Left == true and mouse.x <= 0 or Left == false and mouse.x >= 0:
		fliper.play("flip")
		await get_tree().create_timer(0.2).timeout
		if mouse.x <= 0:
			anim.flip_h = true
			Left = false
		if mouse.x >= 0:
			anim.flip_h = false
			Left = true


func create_after_image():
	if ghost_timer.is_stopped():
		var new_ghost = ghost.instantiate()
		new_ghost.position = position
		new_ghost.flip_h = anim.flip_h
		new_ghost.animation = anim.animation
		new_ghost.frame = anim.frame
		get_tree().root.call_deferred("add_child", new_ghost)
		ghost_timer.start()
	
	

func parry(gun_direction, parry_force):
	Target = gun_direction 
	enemy_body.velocity.y = 0
	momentun += 2700
	collision_mask = 4
	gravity= 0
	paried = true
	charge_timer.stop()
	enemy_body.look_at(gun_direction)
	enemy_body.rotation_degrees -= 90


func _on_navigation_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.position
	next_path_position = navigation_agent_2d.get_next_path_position()


func _on_charge_timer_timeout() -> void:
	var new_explosion = Explosion.instantiate()
	new_explosion.position = barrel_origin.global_position
	new_explosion.damage = 0
	new_explosion.player_made = paried
	get_tree().root.call_deferred("add_child", new_explosion)
	queue_free()
