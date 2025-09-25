extends BaseItemStrat
class_name ShapBullets


func bullet_boost(bullet:Bullet):
	bullet.pierce +=  int(ComboCount.comboCount/10)
