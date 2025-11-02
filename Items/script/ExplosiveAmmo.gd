extends EffectAdder
class_name ExplosiveAmmo

func bullet_boost(_bullet: Bullet):
	if randi() % 100 <= ComboCount.comboCount/2:
		var new_effect = effect.instantiate()
		_bullet.status_manager.new_effect(new_effect)
