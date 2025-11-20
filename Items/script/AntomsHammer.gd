extends BaseItemStrat
class_name SpinHammer

func apply_boost(_player : Player):
	_player.dash_knockback *= 2
	_player.dash_area.scale *= 1.5
	_player.dash_area.visible = true
