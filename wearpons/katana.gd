extends CharacterBody2D

signal swap_out

@export var bullet : PackedScene
@export var alt_fire : PackedScene
@export var swing_anim : PackedScene

@export var bullet_count: int = 1
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D

@onready var anim = $anim
@onready var gunsprite = $anim_maneger/gunsprite
@onready var smear_over = $anim_maneger/smear_over
@onready var smear_under = $anim_maneger/smear_under
@onready var atack_cooldown = $attack_cooldown
@onready var reload_timer = $reload_timer
@onready var max_reload = $max_reload
@onready var reload = $reload
@onready var nuzzel = $nuzzel
@onready var anim_tree = $AnimationTree
@onready var ammo = $ammo
@onready var max_ammo = $max_ammo
@onready var charge_level = $charge_level
@onready var max_charge = $max_charge
@onready var dash_position = $Marker2D
@onready var anim_maneger = $anim_maneger

var mouse
var Left = true
var charging = false
var charge_text = false
var charged = false
@export var shooting = false
var melee_mode = false
var bullet_direction
var attack_type = 1
var left = Vector2(-1,0)
var rigth = Vector2(1,0)




func follow_mouse():
	mouse = get_global_mouse_position()
	bullet_direction = (-barrel_origin.global_position + global_position).normalized()
	var dire = global_position - get_global_mouse_position()
	
	if atack_cooldown.is_stopped():
		if dire.dot(left) < dire.dot(rigth):
			rotation_degrees = 180
			anim_maneger.scale.y = -1
			
		else:
			rotation_degrees = 0
			anim_maneger.scale.y = 1
		
	

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		shooting = true
	if event.is_action_released("shoot"):
		shooting = false
	
	
		

	if event.is_action_pressed("alt_fire") and ammo.ammo >= 4:
		
		charging = true
		
	if event.is_action_released("alt_fire") and charging == true:
		melee_mode = true
		alt_laser()
		charging = false
		
		
		
	




func shoot():
	if atack_cooldown.is_stopped():
		if attack_type == 1:
			anim_tree["parameters/conditions/attack_1"] = true
			anim_tree["parameters/conditions/attack_2"] = false
			anim_tree["parameters/conditions/alt_fire"] = false
			anim_tree["parameters/conditions/default"] = false
			var new_swing = swing_anim.instantiate()
			new_swing.swing_type = 1
			get_parent().get_parent().get_parent().call_deferred("add_child", new_swing)
			
			attack_type = 2
		
		elif attack_type == 2:
			anim_tree["parameters/conditions/attack_1"] = false
			anim_tree["parameters/conditions/attack_2"] = true
			anim_tree["parameters/conditions/alt_fire"] = false
			anim_tree["parameters/conditions/default"] = false
			var new_swing = swing_anim.instantiate()
			new_swing.swing_type = 2
			
			attack_type = 1
			
			
		
		
		
		look_at(mouse)
		atack_cooldown.start()
		reload_timer.start()
		if ammo.ammo < 4:
			ammo.ammo += 1
		
		
		

func alt_laser():
	if ammo.ammo >= 4:
		if atack_cooldown.is_stopped():
			look_at(mouse)
			anim_tree["parameters/conditions/attack_1"] = false
			anim_tree["parameters/conditions/attack_2"] = false
			anim_tree["parameters/conditions/alt_fire"] = true
			anim_tree["parameters/conditions/default"] = false
			var new_swing = swing_anim.instantiate()
			new_swing.swing_type = 1
			get_parent().get_parent().get_parent().call_deferred("add_child", new_swing)
			get_parent().get_parent().get_parent().position = dash_position.global_position
				
			
			var new_alt = alt_fire.instantiate()
			new_alt.position = barrel_origin.global_position if barrel_origin else global_position
			new_alt.rotation = global_rotation
			get_tree().root.call_deferred("add_child", new_alt)
			
			ammo.ammo -=4
			reload_timer.start()
			atack_cooldown.start()
		

func _on_melee_hitbox_area_entered(area):
	if area.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 2
		attack.direction = bullet_direction
		attack.soft = true
		area.handle_hit(attack)

func _process(_delta):
	
	if shooting == true: 
		shoot()
	if atack_cooldown.is_stopped():
		anim_tree["parameters/conditions/attack_1"] = false
		anim_tree["parameters/conditions/attack_2"] = false
		anim_tree["parameters/conditions/alt_fire"] = false
		anim_tree["parameters/conditions/default"] = true
	
func _physics_process(_delta):
	follow_mouse()

func _on_melee_hitbox_body_entered(body):
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 2
		attack.direction = bullet_direction
		attack.soft = true
		body.handle_hit(attack)


func _on_alt_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 3
		attack.direction = bullet_direction
		attack.soft = false
		area.handle_hit(attack)


func _on_alt_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 3
		attack.direction = bullet_direction
		attack.soft = false
		body.handle_hit(attack)
