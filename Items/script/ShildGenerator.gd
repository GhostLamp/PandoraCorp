extends BaseItemStrat
class_name ShildGenarator

var active = true

func on_player_damaged(player:Player):
	if !active:
		return
	
	player.invulnerability()
	player.stylish("shildbreak")
	var new_explosion = scene.instantiate()
	new_explosion.damage = 5
	new_explosion.position = player.coli.position
	player.call_deferred("add_child", new_explosion)
	active = false
	await player.get_tree().create_timer(100).timeout
	cooldown()
	


func cooldown():
	active = true
