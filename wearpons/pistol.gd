extends Gun


@onready var gunsprite = $anim_maneger/gunsprite
@onready var charge_sprite = $anim_maneger/charge

@export var parry_force : int
@onready var alt_fire_timer:Timer = $alt_fire_timer


var Left = true
var charging = false
var charge_text = false
var melee_mode = false
var alt_ready = false





func charge_texture():
	if alt_ready == true:
		charge_sprite.visible = true
	else:
		charge_sprite.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		shooting = true
	if event.is_action_released("shoot"):
		shooting = false
	
	
	if alt_fire_timer.is_stopped():
		if event.is_action_pressed("alt_fire") and ammo.ammo >= 4:
			charging = true
			return
		
		if event.is_action_released("alt_fire") and ammo.ammo >= 4:
			melee_mode = true
			charging = false
			alt_laser()
	else:
		if event.is_action_pressed("alt_fire"):
			melee()



func charge_up(delta):
	if charging == true:
		if charge_level.charge < charge_level.max_charge:
			charge_level.charge += delta*3
	else:
		charge_level.charge -=  delta
	



func shoot():
	if atack_cooldown.is_stopped() and ammo.ammo >= basic_shot_cost:
		get_parent().weapon_boost(self)
		for i in bullet_count:
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
			new_bullet.damage = basic_shot_damage
			new_bullet.quick = true
			new_bullet.speed = basic_shot_speed
			if bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_bullet.global_rotation = (global_rotation + randf_range(arc_rad/2,-arc_rad/2))
			get_tree().root.call_deferred("add_child", new_bullet)
			get_parent().apply_items(new_bullet)
			
		bullet_count = base_bullet_count
		atack_cooldown.start()
		reload_timer.start()
		ammo.ammo -= basic_shot_cost
		reload.reload = 0
		
		anim_tree["parameters/conditions/shooting"] = true
		await get_tree().create_timer(0.1875).timeout
		anim_tree["parameters/conditions/shooting"] = false


func alt_laser():
	if ammo.ammo >= alt_shot_cost:
		for i in bullet_count:
			var new_alt:Alt_fire = alt_fire.instantiate()
			new_alt.damage = alt_shot_damage
			new_alt.position = barrel_origin.global_position if barrel_origin else global_position
			new_alt.bounces *= charge_level.charge
			if bullet_count == 1:
				new_alt.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_alt.global_rotation = ( global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_alt)
		
		
		atack_cooldown.start()
		reload_timer.start()
		ammo.ammo -= alt_shot_cost
		reload.reload = 0
		alt_fire_timer.start()
		alt_ready = false
		
		anim_tree["parameters/conditions/alt_fire"] = true
		await get_tree().create_timer(0.1875).timeout
		anim_tree["parameters/conditions/alt_fire"] = false
		


func melee():
	if atack_cooldown.is_stopped():
		reload_timer.start()
		reload.reload = 0
		melee_mode = true
		anim_tree["parameters/conditions/alt_melee"] = true
		await get_tree().create_timer(0.5).timeout
		anim_tree["parameters/conditions/alt_melee"] = false
		melee_mode = false



func animate():
	if alt_fire_timer.is_stopped() and charging == false:
		anim_tree["parameters/conditions/idle"] = true
		anim_tree["parameters/conditions/charged"] = false
	else:
		anim_tree["parameters/conditions/idle"] = false
		anim_tree["parameters/conditions/charged"] = true
	
	if ammo.ammo == 0:
		anim_tree["parameters/conditions/no_ammo"] = true
		anim_tree["parameters/conditions/has_ammo"] = false
	else:
		anim_tree["parameters/conditions/no_ammo"] = false
		anim_tree["parameters/conditions/has_ammo"] = true



func _physics_process(delta: float) -> void:
	if ammo.ammo < ammo.max_ammo:
		update_reload(delta)
	else:
		alt_fire_timer.stop()
	
	follow_mouse()

func _process(delta):
	Mouse.mouse_type = Mouse.mouseType.BulletMouse
	charge_up(delta)
	if shooting == true:
		shoot()
	charge_texture()
	animate()

func _on_melee_hitbox_body_entered(body):
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 5
		attack.direction = bullet_direction
		attack.soft = true
		body.handle_hit(attack)
		HitstopManeger.hitstop_weak()
