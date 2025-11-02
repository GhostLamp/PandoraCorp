extends SingleUseWeapon
class_name HeldEnemy
var enemy:Enemy 

func _ready() -> void:
	get_parent().add_weapon(self)
	get_parent().connect_signals(self)
	enemy.velocity *= 0
	
	if texture:
		sprite_2d.texture = texture
		
		if texture_region:
			sprite_2d.region_enabled = true
			sprite_2d.region_rect = texture_region
	
	
	enemy.held = true
	enemy.velocity *= 0 
	enemy.set_collision_layer_value(2,false)
	enemy.set_process(false)
	enemy.state_machine.set_state("chasing")

func follow_mouse():
	if !is_instance_valid(enemy):
		emit_signal('remove_weapon')
		queue_free()
		return
	
	mouse = get_global_mouse_position()
	if mouse < global_position:
		enemy.anim.scale.x = -1
	if mouse > global_position :
		enemy.anim.scale.x = 1
	bullet_direction = (-barrel_origin.global_position + global_position).normalized()
	enemy.global_position = sprite_2d.global_position
	enemy.look_at(bullet_direction)
	look_at(mouse)


func shoot():
	var new_bullet:TrownEnemy = bullet.instantiate()
	new_bullet.position = barrel_origin.global_position if barrel_origin else global_position
	if bullet_sprite:
		new_bullet.text =  bullet_sprite
		
		if bullet_region:
			new_bullet.text_region = bullet_region
				
			
	new_bullet.quick = true
	new_bullet.enemy = enemy
	new_bullet.damage = enemy.health_stat.health
	new_bullet.speed = basic_shot_speed
	new_bullet.rotation = global_rotation
	get_tree().root.call_deferred("add_child", new_bullet)
	
	if effect:
		var new_effect = effect.instantiate()
		new_bullet.status_manager.new_effect(new_effect)
			
	look_at(mouse)
	emit_signal('remove_weapon')
	queue_free()
		
