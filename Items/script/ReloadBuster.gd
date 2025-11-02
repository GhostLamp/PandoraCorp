extends BaseItemStrat
class_name ReloadBuster

func on_reload(player:Player,ammo,_max_ammo):
	var enemy_maneger:EnemyManeger = player.currentRoom.enemy_manager
	if enemy_maneger.enemies.size() > 0:
		for i in ammo:
			var enemy_chosen = enemy_maneger.enemies.pick_random()
			var targeted_ray:TargetedRay = scene.instantiate()
			targeted_ray.global_position = player.global_position
			targeted_ray.speed = 2000
			targeted_ray.delay = -i * 0.1
			targeted_ray.look_at(enemy_chosen.global_position)
			targeted_ray.target_enemy = enemy_chosen
			player.get_tree().current_scene.call_deferred("add_child",targeted_ray)
