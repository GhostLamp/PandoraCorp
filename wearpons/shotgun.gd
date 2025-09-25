extends CharacterBody2D


@export var bullet : PackedScene
@export var alt_fire : PackedScene

@export var bullet_count: int = 1
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D
@export var gas_origin: Marker2D

@onready var anim = $amin
@onready var gauge = $Sprite2D
@onready var gunsprite = $gunsprite
@onready var atack_cooldown = $attack_cooldown
@onready var reload_timer = $reload_timer
@onready var nuzzel = $nuzzel
@onready var alt_charge = $alt_charge
@onready var alt_fire_timer = $alt_fire_timer
@onready var anim_tree = $AnimationTree
@onready var ammo = $ammo
@onready var max_ammo = $max_ammo
@onready var reload = $reload
@onready var max_reload = $max_reload
@onready var gauge_tree = $gauge_tree
@onready var charge_level = $charge_level
@onready var max_charge = $max_charge

var mouse
var Left = true
var charging = false
var charge_text = false
var charged = false
@export var shooting = false
var melee_mode = false
var bullet_direction
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
		if charge_level.charge < max_charge.max_charge:
			charge_level.charge += delta
	else:
		charge_level.charge -=  delta
	charge_level.charge = clamp(charge_level.charge, 0 , max_charge.max_charge)
	
	frame = float(charge_level.charge * 12)
	if frame == 0:
		frame = 1
	if frame > 11:
		frame = 0
	gauge.frame = frame


func shoot():
	if atack_cooldown.is_stopped() and ammo.ammo > 0 and alt_fire_timer.is_stopped():
		for i in bullet_count:
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
			new_bullet.damage = 0.5
			new_bullet.speed = 1500
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
		ammo.ammo -= 1
		reload.reload = 0
		
		anim_tree["parameters/conditions/shooting"] = true
		await get_tree().create_timer(0.1875).timeout
		anim_tree["parameters/conditions/shooting"] = false

func alt_laser():
	
	if ammo.ammo > 3:
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
		ammo.ammo -= 4
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


var reloaded = true
func update_reload():

	if reload_timer.is_stopped() and ammo.ammo < max_ammo.max_ammo and alt_charge.is_stopped():
		reload.reload += 1 
		
	if alt_charge.is_stopped():
		pass
	else:
		gunsprite.rotation = 0
		reload.reload = 0
		
	if reload.reload == max_reload.max_reload:
		ammo.ammo = max_ammo.max_ammo
		anim_tree["parameters/conditions/has_gas"] = true
		if reloaded == true:
			get_parent().reload_boost()
			reloaded = false
	
	if reload.reload > 0 and reload.reload < max_reload.max_reload:
		gunsprite.rotation += 1
		reloaded = true
	else:
		gunsprite.rotation = 0





	



func _on_melee_hitbox_area_entered(area):
	if area.is_in_group("projectile"):
		HitstopEfect.hitstop_efect_short()
		HitstopManeger.hitstop_short()
		area.get_parent().parry(bullet_direction)
		

func _process(delta):
	
	if shooting == true:
		shoot()
	charge_up(delta)
	
func _physics_process(_delta):
	update_reload()
	follow_mouse()

func _on_melee_hitbox_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit(5, bullet_direction)
