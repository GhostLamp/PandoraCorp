extends Enemy


@export var ghost : PackedScene
@export var char_color: Color


@onready var fliper = $fliper
@onready var anim_tree = $AnimationTree
@onready var attack_timer = $attack_timer
@onready var ghost_timer = $ghost_timer
@onready var parry_area = $parry_area/CollisionShape2D2
@onready var collision = $CollisionShape2D2
@onready var pos = $body
@onready var status_manager = $status_manager
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var anim_maneger: Node2D = $body/anim_maneger
@onready var anim: Sprite2D = $body/anim_maneger/Sprite2D


enum state {CHASING, CHARGING, AIRBORN, STUNNED, ATTACKING, DEAD}
var enemy_state = state.CHASING




func _process(delta):
	collision.position = pos.position
	if knock_down.is_stopped():
		if enemy_state == state.CHASING:
			chasing(delta)
		elif enemy_state == state.CHARGING:
			charging(delta)
		elif enemy_state == state.AIRBORN:
			airborn()
		elif enemy_state == state.STUNNED:
			Stunned(delta)
		elif enemy_state == state.ATTACKING:
			attacking(delta)
			create_after_image()
		
		flipping(delta)
	move_and_slide()
	

func _physics_process(_delta):
	
	if Yvel < 0:
		enemy_state = state.AIRBORN
	else:
		pos.velocity = Vector2(0,0)
		pos.position = Vector2(0,0)
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
	pos.velocity.y += gravity
	Yvel += gravity 
	

func chasing(delta):
	Target = (next_path_position - global_position).normalized()
	if Yvel >= 0:
		velocity = Target * speed_stat.speed
	
	
	if charge_level < 0:
		charge_level += delta
	else:
		ray_cast_2d.look_at(player.colision.global_position)
		if ray_cast_2d.is_colliding():
			
			if ray_cast_2d.get_collider().has_method("handle_damage"):
				agro = true

func charging(delta):
	velocity =+ Target * speed_stat.speed / -5
	momentun = speed_stat.speed * 3
	Target = (player.colision.global_position - global_position).normalized()
	charge_level += delta*2
	if charge_level >= 1:
		is_attacking = true



func attacking(delta):
	if Yvel >= 0:
		velocity = Target * momentun
		
		parry_area.disabled = false
		
	var colision_info = move_and_collide(Target)
	if colision_info:
		Target = Target.bounce(colision_info.get_normal())
		parry_area.disabled = true
		stunned = true
		charge_level = 1.2
		var tween = get_tree().create_tween()
		tween.tween_property(self,"momentun",0,1)
		
		anim_tree["parameters/conditions/Bonk"] = true
		anim_tree["parameters/conditions/is_agro"] = false
		await get_tree().create_timer(delta).timeout
		anim_tree["parameters/conditions/Bonk"] = false
		
	charge_level -= delta*2
	if charge_level <= 0:
		attackEnd()

func Stunned(delta):
	is_attacking = false
	charge_level -= delta
	if Yvel >= 0:
			velocity = Target * momentun / 5
	if charge_level <= 0:
		stunned = false
		attackEnd()

func jump(vel):
	if enemy_state != state.AIRBORN:
		Yvel = vel
		pos.velocity.y = vel/2




func flipping(delta):
	var mouse = Target
	if mouse.x >= 0:
		mouse.x = -1
	else:
		mouse.x = 1
	flip_scale = flip_scale.move_toward(mouse, 10*delta)
	
	anim_maneger.scale.x = flip_scale.x

func animate():
	if enemy_state == state.CHASING:
		anim_tree["parameters/conditions/Default"] = true
		anim_tree["parameters/conditions/is_agro"] = false
	if enemy_state == state.CHARGING:
		anim_tree["parameters/conditions/Default"] = false
		anim_tree["parameters/conditions/is_agro"] = true
	


func attackEnd():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity",Vector2(0,0),1)
	charge_level = -0.5
	is_attacking = false
	parry_area.disabled = true
	agro = false
	anim_tree["parameters/conditions/Default"] = true
	anim_tree["parameters/conditions/is_agro"] = false

func create_after_image():
	if ghost_timer.is_stopped():
		var new_ghost = ghost.instantiate()
		new_ghost.position = pos.global_position - Vector2(0,7)
		new_ghost.scale = anim_maneger.scale
		new_ghost.texture = anim.texture
		new_ghost.hframes = anim.hframes
		new_ghost.vframes = anim.vframes
		new_ghost.frame = anim.frame
		new_ghost.char_color = char_color
		get_tree().root.call_deferred("add_child", new_ghost)
		ghost_timer.start()

func parry(bullet_direction, _parry_force):
	Target = bullet_direction
	stunned = true
	velocity = Target * momentun * 5
	var tween = get_tree().create_tween()
	tween.tween_property(self,"momentun",0,2)
	anim_tree["parameters/conditions/Bonk"] = true
	anim_tree["parameters/conditions/is_agro"] = false
	await get_tree().create_timer(0.01).timeout
	anim_tree["parameters/conditions/Bonk"] = false
	style.emit("parried")
	




func _on_atack_area_body_entered(body: Node2D) -> void:
	if body.has_method("handle_damage"):
		body.handle_damage()


func _on_navigation_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.colision.global_position
	next_path_position = navigation_agent_2d.get_next_path_position()
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
