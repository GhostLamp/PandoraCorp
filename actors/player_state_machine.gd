extends State
class_name PlayerStateMachine

var current_state:State
var states:Array[State]

func _ready() -> void:
	player = get_parent()
	
	for child in get_children():
		if child is State:
			states.append(child)
	
	current_state = states[0]

func state_process(delta:float):
	current_state.state_process(delta)

func force_swap(newStateName):
	current_state.swapState(newStateName)

func set_state(newStateName):
	if newStateName == current_state.stateName:
		return
	for i in states.size():
		if states[i].stateName == newStateName:
			current_state = states[i]
	
	current_state.state_enter()
