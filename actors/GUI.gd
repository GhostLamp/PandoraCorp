extends Node2D

@onready var ammo_display = $ammo_display
@onready var reload_bar = $reload_bar
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


func _process(_delta):
	set_weapon(get_parent().get_parent().gun_maneger.set_weapon())
	return

func set_weapon(weapon:Gun):
	reload_bar.max_value = weapon.reload.max_reload
	reload_bar.value = weapon.reload.reload
	ammo_display.text = str(weapon.ammo.ammo)
	
	texture_progress_bar.max_value = weapon.ammo.max_ammo
	texture_progress_bar.value = weapon.ammo.ammo
	
	if weapon.texture_under:
		texture_progress_bar.texture_under = weapon.texture_under
	if weapon.texture_progress:
		texture_progress_bar.texture_progress = weapon.texture_progress
	
	if weapon.reload.reload == 0 or weapon.reload.reload == weapon.reload.max_reload:
		reload_bar.visible = false
	else:
		reload_bar.visible = true
