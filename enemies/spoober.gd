extends Enemy




@onready var fliper = $fliper
@onready var anim_tree = $AnimationTree
@onready var attack_timer = $attack_timer
@onready var parry_area = $parry_area/CollisionShape2D2
@onready var collision = $CollisionShape2D2
@onready var status_manager = $status_manager
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


func _process(delta):
	collision.position = pos.position
	if !spawned:
		return
	
	check_tile(delta)
	if knock_down.is_stopped():
		state_machine.state_process(delta)
		
	move_and_slide()
	

func _physics_process(_delta):
	animate()
	

func flipping():
	var mouse = (next_path_position - global_position).normalized()
	if mouse.x >= 0:
		mouse = Vector2(-1,1)
	else:
		mouse = Vector2(1,1)
	anim.scale = mouse



func animate():
	if state_machine.current_state.name == "chasing":
		anim_tree["parameters/conditions/Default"] = true
		anim_tree["parameters/conditions/is_agro"] = false
	if state_machine.current_state.name == "charging":
		anim_tree["parameters/conditions/Default"] = false
		anim_tree["parameters/conditions/is_agro"] = true
		
	



func parry(bullet_direction, _parry_force):
	Target = bullet_direction
	stunned = true
	velocity = Target * speed_stat.current_speed * 5
	var tween = get_tree().create_tween()
	tween.tween_property(speed_stat,"current_speed",0,2)
	anim_tree["parameters/conditions/Bonk"] = true
	anim_tree["parameters/conditions/is_agro"] = false
	await get_tree().create_timer(0.01).timeout
	anim_tree["parameters/conditions/Bonk"] = false
	style.emit("parried")
	


func _on_atack_area_body_entered(body: Node2D) -> void:
	if body.has_method("handle_damage"):
		body.handle_damage(damage)
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 1
		attack.direction = Target
		attack.knockback = 10
		body.handle_hit(attack)


func _on_navigation_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.coli.global_position
	next_path_position = navigation_agent_2d.get_next_path_position()
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
