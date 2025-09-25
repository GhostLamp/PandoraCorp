extends CharacterBody2D

signal swap_out
signal bullet_shot

@export var bullet : PackedScene
@export var alt_fire : PackedScene

@export var base_bullet_count: int = 1
@export var bullet_count: int = 1
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D


@export var parry_force : int

@onready var anim = $amin
@onready var gunsprite = $gunsprite
@onready var charge_sprite = get_node("charge")
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
@onready var charge_level = $charge_level
@onready var max_charge = $max_charge


var mouse
var Left = true
var charging = false
var charge_text = false
@export var shooting = false
var melee_mode = false
var alt_ready = false
var bullet_direction



func follow_mouse():
	mouse = get_global_mouse_position()
	if mouse < global_position:
		gunsprite.flip_v = true
		charge_sprite.flip_v = true
	if mouse > global_position :
		gunsprite.flip_v = false
		charge_sprite.flip_v = false
	
	
	bullet_direction = (barrel_origin.global_position - global_position).normalized()
	look_at(mouse)

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
			
		if event.is_action_released("alt_fire") and alt_ready == true and charging == true:
			melee_mode = true
			alt_laser()
			charging = false
			alt_ready = false
		elif event.is_action_released("alt_fire") and ammo.ammo > 3 and charging == true:
			charging = false
			
	else:
		if event.is_action_pressed("alt_fire"):
			melee()

func charge_up(delta):
	if charging == true:
		if charge_level.charge < max_charge.max_charge:
			charge_level.charge += delta*3
		if charge_level.charge >= max_charge.max_charge:
			alt_ready = true
		
	else:
		charge_level.charge -=  delta
	



func shoot():
	if atack_cooldown.is_stopped() and ammo.ammo > 0:
		get_parent().weapon_boost(self)
		for i in bullet_count:
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
			new_bullet.damage = 1
			new_bullet.quick = true
			new_bullet.speed = 5000
			if bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_bullet.global_rotation = ( global_rotation + increment * i - arc_rad / 2)
			get_tree().root.call_deferred("add_child", new_bullet)
			get_parent().apply_items(new_bullet)
			
		bullet_count = base_bullet_count
		atack_cooldown.start()
		reload_timer.start()
		ammo.ammo -= 1
		reload.reload = 0
		
		anim_tree["parameters/conditions/shooting"] = true
		await get_tree().create_timer(0.1875).timeout
		anim_tree["parameters/conditions/shooting"] = false


func alt_laser():
	
	if ammo.ammo > 3:
		for i in bullet_count:
			var new_alt = alt_fire.instantiate()
			new_alt.damage = 2
			new_alt.position = barrel_origin.global_position if barrel_origin else global_position
			if bullet_count == 1:
				new_alt.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_alt.global_rotation = ( global_rotation + increment * i - arc_rad / 2)
			
			get_tree().root.call_deferred("add_child", new_alt)
		
		
		atack_cooldown.start()
		reload_timer.start()
		ammo.ammo -= 4
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

var reloaded = true
func update_reload():
	if reload_timer.is_stopped() and ammo.ammo < max_ammo.max_ammo and alt_charge.is_stopped():
		reload.reload += 1 
		
	if alt_charge.is_stopped():
		pass
	else:
		gunsprite.rotation = 0
		reload.reload = 0
		charge_sprite.rotation = 0
		
	if reload.reload == max_reload.max_reload:
		ammo.ammo = max_ammo.max_ammo
		alt_fire_timer.stop()
		if reloaded == true:
			get_parent().reload_boost()
			reloaded = false
	
	if reload.reload > 0 and reload.reload < max_reload.max_reload:
		gunsprite.rotation += 1
		charge_sprite.rotation += 1
		reloaded = true
	else:
		gunsprite.rotation = 0
		charge_sprite.rotation = 0



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


func _on_alt_charge_timeout():
	if charging == true:
		alt_ready = true
	



		

func _process(delta):
	charge_up(delta)
	if shooting == true:
		shoot()
	charge_texture()
	animate()
	
func _physics_process(_delta):
	update_reload()
	follow_mouse()

func _on_melee_hitbox_body_entered(body):
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 5
		attack.direction = bullet_direction
		attack.soft = true
		body.handle_hit(attack)
		HitstopManeger.hitstop_weak()
