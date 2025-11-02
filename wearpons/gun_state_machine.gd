extends State
class_name GunStateMachine

var current_state:State
var states:Array[State]
var gun:Gun

func _ready() -> void:
	gun = get_parent()
	
	for child in get_children():
		if child is State:
			states.append(child)
	
	current_state = states[0]

func state_process(delta:float):
	current_state.state_process(delta)

func force_swap(newStateName):
	current_state.swapState(newStateName)

func set_state(newStateName):
	if newStateName =="controlling":
		var gun_maneger = player.gun_maneger
		gun_maneger.inactive = true
		gun_maneger.switch_weapons(gun_maneger.weapons[gun_maneger.current_weapon_index])
	
	for i in states.size():
		if states[i].stateName == newStateName:
			current_state = states[i]
