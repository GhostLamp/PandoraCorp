extends Enemy


@export var bullet : PackedScene

@export var bullet_count : int
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D


@onready var nuzzel_holder: Node2D = $nuzzelHolder
@onready var anim = $body/anim_maneger
@onready var anim_tree = $body/anim_maneger/AnimationTree
@onready var collision = $CollisionShape2D2
@onready var body = $body
@onready var status_maneger = $status_manager
@onready var ghost_timer = $ghost_timer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var status_manager: Node2D = $status_manager2



enum state {CHASING, CHARGING, ATTACKING, AIRBORN, STUNNED}
var enemy_state = state.CHASING



func _process(delta):
	collision.position = body.position
	
	
	if knock_down.is_stopped():
		if enemy_state == state.CHASING:
			chasing(delta)
			flipping()
			
		if enemy_state == state.ATTACKING:
			attacking(delta)
			flipping()
			
		if enemy_state == state.AIRBORN:
			airborn()
		if enemy_state == state.STUNNED:
			Stunned()
		if enemy_state == state.CHARGING:
			charging(delta)
			flipping()
		
	
	move_and_slide()

func _physics_process(_delta):
	
	if Yvel < 0:
		enemy_state = state.AIRBORN
	else:
		if stunned == true:
			enemy_state = state.STUNNED
		else:
			if agro == true:
				if is_attacking:
					enemy_state = state.ATTACKING
				else:
					enemy_state = state.CHARGING
			else:
				enemy_state = state.CHASING
		
	animate()
	

func airborn():
	agro = false
	body.velocity.y += gravity
	Yvel += gravity 
	

func chasing(delta):
	Target = (next_path_position - global_position).normalized()
	if Yvel >= 0:
		velocity = Target * speed_stat.speed
	
	ray_cast_2d.look_at(player.colision.position)
	if charge_level < 0:
		charge_level += delta
	else:
		ray_cast_2d.look_at(player.colision.global_position)
		if ray_cast_2d.is_colliding():
			
			if ray_cast_2d.get_collider().has_method("handle_damage"):
				agro = true

func charging(delta):
	velocity =Vector2(0,0)
	barrel_origin.scale += Vector2(1,1)*delta
	nuzzel_holder.look_at(player.colision.global_position)
	Target = (player.colision.global_position - position).normalized()
	charge_level += delta*2
	if charge_level >= 2:
		is_attacking = true

func attacking(_delta):
	Target = (player.position - position).normalized()
	anim_tree["parameters/conditions/attacking"] = true
	await get_tree().create_timer(_delta).timeout
	anim_tree["parameters/conditions/attacking"] = false
	for i in bullet_count:
		var new_bullet = bullet.instantiate()
		new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
		new_bullet.damage = 1
		if bullet_count == 1:
			new_bullet.rotation = barrel_origin.global_rotation
		else:
			var arc_rad = deg_to_rad(arc)
			var increment = arc_rad / (bullet_count - 1)
			new_bullet.global_rotation = ( barrel_origin.global_rotation + increment * i - arc_rad / 2)
		get_tree().root.call_deferred("add_child", new_bullet)
		
	attackEnd()
	
	
	flipping()

func attackEnd():
	charge_level = -1.5
	is_attacking = false
	agro = false
	barrel_origin.scale = Vector2(0.01,0.01)
	anim_tree["parameters/conditions/CHASING"] = true
	anim_tree["parameters/conditions/CHARGING"] = false

func Stunned():
	if knock_down.is_stopped() and Yvel >= 0:
			velocity = Target * momentun / 5
	await get_tree().create_timer(1.2).timeout
	if stunned != false:
		stunned = false
		charge_level = 0
		agro = false
	

func jump(vel):
	if enemy_state != state.AIRBORN:
		Yvel = vel
		body.velocity.y = vel/2


func flipping():
	var mouse = (next_path_position - global_position).normalized()
	if mouse.x >= 0:
		mouse = Vector2(1,1)
	else:
		mouse = Vector2(-1,1)
	anim.scale = mouse
	

func animate():
	if enemy_state == state.CHASING:
		anim_tree["parameters/conditions/CHASING"] = true
		anim_tree["parameters/conditions/CHARGING"] = false
	if enemy_state == state.CHARGING:
		anim_tree["parameters/conditions/CHASING"] = false
		anim_tree["parameters/conditions/CHARGING"] = true



func create_after_image():
	pass




func _on_navigation_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.position
	next_path_position = navigation_agent_2d.get_next_path_position()
