extends BaseItemStrat
class_name GunpowderSmoke
var activation_timer:int = 5

func on_combo_gain(player:Player):
	activation_timer -= 1
	if activation_timer <= 0:
		activation_timer = 5
		var smoke = scene.instantiate()
		player.get_tree().current_scene.call_deferred("add_child",smoke)
		smoke.global_position = player.global_position
