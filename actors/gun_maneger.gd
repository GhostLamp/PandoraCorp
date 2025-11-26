extends Node2D
class_name PlayerGunManager

var current_weapon_index = 0

@onready var current_weapon:Gun = $gun
@onready var player: Player = $"../.."


var inactive:bool = false
var weapons: Array = []
var weapon_count 



func _ready():
	weapons = get_children()
	
	for weapon in weapons:
		weapon.hide()
		weapon.set_process_unhandled_input(false)
		weapon.set_process(false)
		connect_signals(weapon)
	current_weapon.show()
	current_weapon.set_process_unhandled_input(true)
	current_weapon.set_process(true)
	current_weapon.swap_in()

func connect_signals(weapon):
	if weapon.has_signal("remove_weapon"):
		weapon.remove_weapon.connect(remove_weapon)

func apply_items(bullet:Bullet):
	for item:BaseItemStrat in player.items:
		item.bullet_boost(bullet)
		

func weapon_boost(weapon):
	for item:BaseItemStrat in player.items:
		item.weapon_boost(weapon)

func reload_boost(ammo,max_ammo):
	for item:BaseItemStrat in player.items:
		item.on_reload(player,ammo,max_ammo)

func _process(_delta):
	if Input.is_action_just_pressed("switch_weapons"):
		if weapons[current_weapon_index].has_method("swap_out"):
			await weapons[current_weapon_index].swap_out()
		current_weapon_index += 1
		if current_weapon_index >= get_child_count():
			current_weapon_index = 0
		switch_weapons(weapons[current_weapon_index])

func set_weapon():
	return current_weapon

func add_weapon(weapon):
	weapons.append(weapon)
	current_weapon_index = weapons.size() - 1
	switch_weapons(weapons[current_weapon_index])

func remove_weapon():
	weapons.pop_at(current_weapon_index)
	if current_weapon_index >= get_child_count()-1:
		current_weapon_index = 0
	switch_weapons(weapons[current_weapon_index])

func switch_weapons(weapon):
	if current_weapon:
		current_weapon.hide()
		current_weapon.set_process_unhandled_input(false)
		current_weapon.set_process(false)
		current_weapon.shooting = false
	
	if inactive:
		return
	
	weapon.show()
	weapon.set_process_unhandled_input(true)
	weapon.set_process(true)
	weapon.swap_in()
	current_weapon = weapon
