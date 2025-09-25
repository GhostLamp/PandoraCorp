extends EffectAdder
class_name MatchBox

var shots = 0

func bullet_boost(_bullet: Bullet):
	if shots <= 0:
		var new_effect = effect.instantiate()
		_bullet.status_manager.new_effect(new_effect)
		shots = 3
	else:
		shots -= 1
