extends BaseItemStrat
class_name ReloadBuster

func on_reload(player:Player):
	var enemy_maneger:EnemyManeger = player.currentRoom.enemy_manager
	if enemy_maneger.enemies.size() > 0:
		var enemy_chosen = enemy_maneger.enemies.pick_random()
		var new_attack:Attack = Attack.new()
		new_attack.damage = 10
		enemy_chosen.handle_hit(new_attack)
