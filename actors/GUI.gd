extends Node2D

@onready var ammo_display = $ammo_display
@onready var reload_bar = $reload_bar

func _process(_delta):
	set_weapon(get_parent().get_parent().gun_maneger.set_weapon())
	return

func set_weapon(weapon):
	ammo_display.text = str(weapon.ammo.ammo)
	reload_bar.max_value = weapon.max_reload.max_reload
	reload_bar.value = weapon.reload.reload
	ammo_display.text = str(weapon.ammo.ammo)
	
	if weapon.reload.reload == 0 or weapon.reload.reload == weapon.max_reload.max_reload:
		reload_bar.visible = false
	else:
		reload_bar.visible = true
