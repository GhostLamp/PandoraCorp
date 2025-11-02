extends Gun



@onready var gunsprite = $anim_maneger/gunsprite
@onready var smear_over = $anim_maneger/smear_over
@onready var smear_under = $anim_maneger/smear_under

@onready var dash_position = $Marker2D

var Left = true
var charging = false
var charged = false
var attack_type = 1




func follow_mouse():
	mouse = get_global_mouse_position()
	bullet_direction = (-barrel_origin.global_position + global_position).normalized()
	var dire = global_position - get_global_mouse_position()
	if atack_cooldown.is_stopped():
		if charging:
			rotation_degrees = 90
			anim_tree["parameters/conditions/default"] = false
			anim_tree["parameters/conditions/waiting"] = true
			return
		
		anim_tree["parameters/conditions/default"] = true
		anim_tree["parameters/conditions/waiting"] = false
		
		if dire.dot(Vector2(-1,0)) < dire.dot(Vector2(1,0)):
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
		var player:Player = get_parent().get_parent().get_parent()
		player.direction = bullet_direction
		player.jump(-1000)
		
	


func shoot():
	if atack_cooldown.is_stopped():
		if attack_type == 1:
			anim_tree["parameters/conditions/attacking"] = true
			await get_tree().create_timer(0.01).timeout
			anim_tree["parameters/conditions/attacking"] = false
			
			attack_type = 2
			anim_tree["parameters/attack/conditions/A1"] = false
			anim_tree["parameters/attack/conditions/A2"] = true
		
		elif attack_type == 2:
			anim_tree["parameters/conditions/attacking"] = true
			await get_tree().create_timer(0.01).timeout
			anim_tree["parameters/conditions/attacking"] = false
			
			attack_type = 1
			anim_tree["parameters/attack/conditions/A1"] = true
			anim_tree["parameters/attack/conditions/A2"] = false
			
		look_at(mouse)
		atack_cooldown.start()
		if ammo.ammo < 4:
			ammo.ammo += 1
		

func alt_laser():
	if ammo.ammo >= 4:
		anim_tree["parameters/conditions/alt_fire"] = true
		await get_tree().create_timer(0.01).timeout
		anim_tree["parameters/conditions/alt_fire"] = false
		ammo.ammo -=4
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
	if charging:
		var coli:CharacterBody2D = get_parent().get_parent()
		if coli.position.y >= -30 and coli.velocity.y > 0:
			alt_laser()
			charging = false
	
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


func _on_alt_hitbox_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		var tiles:TileMapLayer = body
		var coords = tiles.get_coords_for_body_rid(body_rid)
		tiles.set_cell(coords,1,Vector2(1,1))


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var coli:CharacterBody2D = get_parent().get_parent()
		coli.velocity.y = -1000
		alt_laser()
		charging = false
