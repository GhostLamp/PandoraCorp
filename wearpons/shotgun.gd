extends Gun





@export var gas_origin: Marker2D


@onready var gauge = $anim_maneger/Sprite2D
@onready var gunsprite = $anim_maneger/gunsprite
@onready var alt_charge = $alt_charge
@onready var alt_fire_timer = $alt_fire_timer
@onready var gauge_tree = $gauge_tree




var Left = true
var charging = false
var charge_text = false
var charged = false
var melee_mode = false
var frame:int



func follow_mouse():
	mouse = get_global_mouse_position()
	if mouse < global_position:
		gunsprite.flip_v = true
		gauge.flip_v = true
	
	if mouse > global_position :
		gunsprite.flip_v = false
		gauge.flip_v = false
	
	bullet_direction = (barrel_origin.global_position - global_position).normalized()
	look_at(mouse)

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		shooting = true
	if event.is_action_released("shoot"):
		shooting = false
	

	if event.is_action_pressed("alt_fire") and ammo.ammo >= 4 and alt_fire_timer.is_stopped():
		
		charging = true
		
	if event.is_action_released("alt_fire") and charging == true:
		alt_laser()
		charging = false
		
		
		
	

func charge_up(delta):
	
	if charging == true:
		if charge_level.charge < charge_level.max_charge:
			charge_level.charge += delta
	else:
		charge_level.charge -=  delta
	charge_level.charge = clamp(charge_level.charge, 0 , charge_level.max_charge)
	
	frame = float(charge_level.charge * 12)
	if frame == 0:
		frame = 1
	if frame > 11:
		frame = 0
	gauge.frame = frame


func shoot():
	if atack_cooldown.is_stopped() and ammo.ammo >= basic_shot_cost and alt_fire_timer.is_stopped():
		for i in bullet_count:
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
			new_bullet.damage = basic_shot_damage
			new_bullet.speed = basic_shot_speed
			
			if bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_bullet.global_rotation = ( global_rotation + increment * i * - arc_rad / 2 + randf_range(-0.2, 0.2) )
			
			get_tree().root.call_deferred("add_child", new_bullet)
			get_parent().apply_items(new_bullet)
		
		atack_cooldown.start()
		reload_timer.start()
		ammo.ammo -= basic_shot_cost
		reload.reload = 0
		
		anim_tree["parameters/conditions/shooting"] = true
		await get_tree().create_timer(0.1875).timeout
		anim_tree["parameters/conditions/shooting"] = false

func alt_laser():
	
	if ammo.ammo >= alt_shot_cost:
		for i in bullet_count - (bullet_count - 1):
			var new_alt:Projectile = alt_fire.instantiate()
			new_alt.position = gas_origin.global_position if gas_origin else global_position
			new_alt.target = mouse
			new_alt.charge = charge_level.charge
			new_alt.dono.append(get_parent().get_parent().get_parent())
			if bullet_count - (bullet_count - 1) == 1:
				new_alt.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_alt.global_rotation = ( global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_alt)
		
		
		reload_timer.start()
		ammo.ammo -= alt_shot_cost
		reload.reload = 0
		alt_fire_timer.start()
		
		if  ammo.ammo >= 4:
			anim_tree["parameters/conditions/alt_fire"] = true
			await get_tree().create_timer(0.1875).timeout
			anim_tree["parameters/conditions/alt_fire"] = false
		else:
			anim_tree["parameters/conditions/no_gas"] = true
			anim_tree["parameters/conditions/has_gas"] = false
			await get_tree().create_timer(0.1875).timeout
			anim_tree["parameters/conditions/no_gas"] = false





func _physics_process(delta: float) -> void:
	if ammo.ammo < ammo.max_ammo:
		update_reload(delta)
	else:
		anim_tree["parameters/conditions/has_gas"] = true
	follow_mouse()

func _process(delta):
	
	if shooting == true:
		shoot()
	
	charge_up(delta)

func _on_melee_hitbox_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit(5, bullet_direction)
