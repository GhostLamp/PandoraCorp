extends State

func state_enter():
	var gun_maneger = player.gun_maneger
	gun_maneger.inactive = true
	gun_maneger.switch_weapons(gun_maneger.weapons[gun_maneger.current_weapon_index])

func state_process(delta:float):
	player.flipping(delta, player.get_global_mouse_position() - player.global_position)
	player.camera_2d


func swapState(newStateName:String):
	var gun_maneger = player.gun_maneger
	gun_maneger.inactive = false
	gun_maneger.switch_weapons(gun_maneger.weapons[gun_maneger.current_weapon_index])
	get_parent().set_state(newStateName)
