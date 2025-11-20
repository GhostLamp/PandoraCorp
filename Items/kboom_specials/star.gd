extends Projectile



@export var explosion_damage = 5
@export var explosive:PackedScene



func _process(delta):
	velocity = speed * direction
	var colision_info = move_and_collide(direction)
	if colision_info:
		if paried == true:
			pass
		else:
			direction = direction.bounce(colision_info.get_normal())
	sprite.rotation += delta * spin
	spin -= drag * delta
	move_and_collide(-direction)
	move_and_slide()



func getClosest_enemy(bullet:Bullet):
	var player:Player = get_tree().current_scene.player
	var enemies:Array = player.currentRoom.enemy_manager.enemies
	for i in enemies:
		if i.held:
			enemies.erase(i)
	if enemies.size() > 0:
		enemies.sort_custom(sort_interection_areas)
		var enemy_chosen = enemies[0]
		return bullet.global_position.direction_to(enemy_chosen.global_position)
	return Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()

func sort_interection_areas(area1, area2):
	var area1_to_player = self.global_position.distance_to(area1.global_position)
	var area2_to_player = self.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Bullet:
		if area.get_parent().quick == true:
			var bullet:Bullet = area.get_parent()
			var new_effect:Explosive = explosive.instantiate()
			
			new_effect.insta_exosion = true
			new_effect.hit_stop = true
			
			bullet.status_manager.new_effect(new_effect)
			bullet.direction = getClosest_enemy(bullet)
			
			queue_free()



func _on_area_2d_body_entered(_body):
	pass

func parry(gun_direction, parry_force):
	direction = gun_direction 
	coli.velocity.y = 0
	speed += 5000
	explosion_damage += parry_force
	collision_mask = 2
	gravity= 0
	paried = true
	
