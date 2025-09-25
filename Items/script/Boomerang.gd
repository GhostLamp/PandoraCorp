extends BaseItemStrat
class_name Boomerang

@export var mult:float
@export var speed_boost:float
func bullet_boost(bullet:Bullet):
	bullet.damage *= mult
	bullet.final_direction = Vector2.RIGHT.rotated(bullet.global_rotation) *speed_boost
