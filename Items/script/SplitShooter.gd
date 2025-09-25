extends BaseItemStrat
class_name SplitShooter

func weapon_boost(weapon):
	weapon.bullet_count += int(ComboCount.comboCount/10)
