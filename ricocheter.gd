extends Node2D

@export var status_type = 5
@export var explosion : PackedScene
var limit = 3

func on_hit(collider):
	var bullet:Bullet = get_parent().get_parent()
	if collider.has_node("health"):
		
		if collider.health_stat.health > get_parent().get_parent().damage:
			return
		
		if limit > 0:
			limit -=1
			bullet.pierce += 1
			bullet.direction = getClosest_enemy(bullet,collider)

func getClosest_enemy(bullet:Bullet,enemy:Enemy):
	var player:Player = get_tree().current_scene.player
	var enemies:Array = player.currentRoom.enemy_manager.enemies
	enemies.erase(enemy)
	
	if enemies.size() > 0:
		enemies.sort_custom(sort_interection_areas)
		var enemy_chosen = enemies[0]
		return bullet.global_position.direction_to(enemy_chosen.global_position)
	return Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()

func sort_interection_areas(area1, area2):
	var area1_to_player = self.global_position.distance_to(area1.global_position)
	var area2_to_player = self.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
